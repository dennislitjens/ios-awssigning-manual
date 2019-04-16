//
//  AwsInteractionManager.swift
//  ManualAwsSigningExample
//
//  Created by Dennis Litjens on 15/04/2019.
//  Copyright © 2019 AppFoundry. All rights reserved.
//

import UIKit
import AWSMobileClient
import os.log
import RxSwift

class UserService {

    var slackUrlParameters: SlackConfig.SlackUrlParameters
    private var networkManager: NetworkManager
    private var userDefaultsService: UserDefaultsService

    init(slackUrlParameters: SlackConfig.SlackUrlParameters, networkManager: NetworkManager, userDefaultsService: UserDefaultsService) {
        self.slackUrlParameters = slackUrlParameters
        self.networkManager = networkManager
        self.userDefaultsService = userDefaultsService
    }

    func openSlackAuthUrl() {
        let url = self.slackUrlParameters.slackAuthURL
            .append("client_id", value: self.slackUrlParameters.slackClientId)
            .append("scope", value: self.slackUrlParameters.slackScope)
            .append("team", value: self.slackUrlParameters.slackTeamId)
            .append("redirect_uri", value: self.slackUrlParameters.slackRedirectUri)

        UIApplication.shared.open(url, options: [:])
    }

    func startAuthFlow(slackCode: String) -> Single<String> {
        do {
            return try self.networkManager.fetchSlackAuthorizationToken(
                slackUrlParameters: self.slackUrlParameters,
                code: slackCode
                ).do(onSuccess: { [weak self] token in
                    self?.userDefaultsService.saveSlackAuthToken(token: SlackAuthTokens(accessToken: token.accessToken, scope: token.scope))
                })
                .flatMap { self.saveAwsCredentials(slackToken: $0.accessToken) }
                .flatMap { try self.networkManager.fetchCognitoAuthToken(slackToken: $0) }
                .flatMap { self.federatedSignin(cognitoTokens: $0) }
                .flatMap { _ in self.saveAwsCredentials(slackToken: "") }
        } catch {
            return Single.error(AWSError.awsSigningError)
        }
    }

    func startRefreshAuthFlow() -> Single<String> {
        if let slackToken = self.userDefaultsService.getSlackAuthToken() {
            AWSMobileClient.sharedInstance().signOut()
            return self.initializeAWSMobileClient()
                .flatMap { _ in self.saveAwsCredentials(slackToken: slackToken.accessToken) }
                .flatMap { try self.networkManager.fetchCognitoAuthToken(slackToken: $0) }
                .flatMap { self.federatedSignin(cognitoTokens: $0) }
                .flatMap { _ in self.saveAwsCredentials(slackToken: "") }
        } else {
            return .just("")
        }
    }

    private func federatedSignin(cognitoTokens: CognitoAuthTokens) -> Single<Void> {
        return Single.create { single in
            AWSMobileClient.sharedInstance().federatedSignIn(
                providerName: IdentityProvider.developer.rawValue,
                token: cognitoTokens.token,
                federatedSignInOptions: FederatedSignInOptions(cognitoIdentityId: cognitoTokens.identityId),
                completionHandler: { (userState, error) in
                    if let userState = userState {
                        os_log("\nSigned in as: %@", type: .debug, userState.rawValue)
                        single(.success(()))
                    } else if let error = error {
                        single(.error(AWSError.awsFederatedSigninFail(error)))
                    }
            }
            )
            return Disposables.create {}
        }
    }

    func saveAwsCredentials(slackToken: String) -> Single<String> {
        return Single.create { single in
            AWSMobileClient.sharedInstance().getAWSCredentials { [weak self] (credentials, error)  in
                if let credentials = credentials, let sessionKey = credentials.sessionKey {
                    let codableCredentials = AwsCredentials(
                        accessKey: credentials.accessKey,
                        secretKey: credentials.secretKey,
                        sessionKey: sessionKey
                    )
                    self?.userDefaultsService.saveAwsCredentials(awsCredentials: codableCredentials)
                    return single(.success(slackToken))
                } else if let error = error {
                    return single(.error(AWSError.awsCredentialsFetchFail(error)))
                }
            }
            return Disposables.create {}
        }
    }

    private func initializeAWSMobileClient() -> Single<Void> {
        return Single.create { single in
            AWSMobileClient.sharedInstance().initialize { (userState, error) in
                if let error = error {
                    return single(.error(error))
                } else if userState != nil {
                    return single(.success(()))
                }
            }
            return Disposables.create {}
        }
    }
}

