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

    func startAuthFlow(slackCode: String) throws {
        let slackAuthTokens = try self.networkManager.fetchSlackAuthorizationToken(
            slackUrlParameters: self.slackUrlParameters,
            code: slackCode
        )
        self.saveAwsCredentials()
        let cognitoAuthToken = try self.networkManager.fetchCognitoAuthToken(slackToken: slackAuthTokens.accessToken)
        self.federatedSignin(cognitoTokens: cognitoAuthToken)
        self.saveAwsCredentials()
    }

    func startRefreshAuthFlow() throws {
        if let slackToken = self.userDefaultsService.getSlackAuthToken() {
            AWSMobileClient.sharedInstance().signOut()
            self.initializeAWSMobileClient()
            self.saveAwsCredentials()
            let cognitoAuthToken = try self.networkManager.fetchCognitoAuthToken(slackToken: slackToken.accessToken)
            self.federatedSignin(cognitoTokens: cognitoAuthToken)
            self.saveAwsCredentials()
        } else {
            os_log("\nNo SlackAuthToken stored in userdefaults.", type: .error)
        }
    }

    private func federatedSignin(cognitoTokens: CognitoAuthTokens) {
        AWSMobileClient.sharedInstance().federatedSignIn(
            providerName: IdentityProvider.developer.rawValue,
            token: cognitoTokens.token,
            federatedSignInOptions: FederatedSignInOptions(cognitoIdentityId: cognitoTokens.identityId),
            completionHandler: { (userState, error) in
                if let userState = userState {
                    os_log("\nSigned in as: %@", type: .debug, userState.rawValue)
                } else if let error = error {
                    os_log("\nFederated signin error: %@", type: .error, error.localizedDescription)
                }
            }
        )
    }

    func saveAwsCredentials() {
        AWSMobileClient.sharedInstance().getAWSCredentials { [weak self] (credentials, error)  in
            if let credentials = credentials, let sessionKey = credentials.sessionKey {
                let codableCredentials = AwsCredentials(
                    accessKey: credentials.accessKey,
                    secretKey: credentials.secretKey,
                    sessionKey: sessionKey
                )
                self?.userDefaultsService.saveAwsCredentials(awsCredentials: codableCredentials)
            }
        }
    }

    private func initializeAWSMobileClient() {
        AWSMobileClient.sharedInstance().initialize { (userState, error) in
            if let error = error {
                os_log("\nError initializing AwsMobileClient: %@", type: .error, error.localizedDescription)
            } else if let state = userState {
                os_log("\nSigned in as: %@", type: .debug, state.rawValue)
            }
        }
    }
}

