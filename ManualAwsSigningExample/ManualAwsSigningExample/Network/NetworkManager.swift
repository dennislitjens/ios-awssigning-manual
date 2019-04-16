//
//  NetworkManager.swift
//  ManualAwsSigningExample
//
//  Created by Dennis Litjens on 15/04/2019.
//  Copyright © 2019 AppFoundry. All rights reserved.
//

import Alamofire
import os.log

class NetworkManager {

    private let session: NetworkSession
    private let requests: NetworkManagerRequests
    var userService: UserService!

    init(session: NetworkSession, requests: NetworkManagerRequests) {
        self.session = session
        self.requests = requests
    }

    func fetchLocationEntries() throws -> [LocationEntry] {
        let request = self.requests.fetchLocationEntriesRequest()
        let sessionResponse = try self.session.perform(request: request)

        return try self.handleResponseWithDataRoot(response: sessionResponse)
    }

    func fetchSlackAuthorizationToken(
        slackUrlParameters: SlackConfig.SlackUrlParameters,
        code: String
        ) throws -> SlackAuthTokens {
        let response = try session.perform(
            request: self.requests.fetchSlackAuthorizationToken(
                clientId: slackUrlParameters.slackClientId,
                clientSecret: slackUrlParameters.slackClientSecret,
                code: code,
                redirectUri: slackUrlParameters.slackRedirectUri
            )
        )
        return try self.handleResponse(response: response)
    }

    func fetchCognitoAuthToken(slackToken: String) throws -> CognitoAuthTokens {
        let request = try self.requests.fetchCognitoAuthToken(with: slackToken)
        let response = try session.perform(request: request)
        return try self.handleResponse(response: response)
    }

    private func handleResponseWithDataRoot<T: Decodable>(response: NetworkResponse) throws -> T {
        return try JSONDecoder().decodeData(T.self, from: response.data, keyedBy: "data")
    }

    private func handleResponse<T: Decodable>(response: NetworkResponse) throws -> T {
        return try JSONDecoder().decode(T.self, from: response.data)
    }

    private func refreshCredentials() throws {
        try self.userService.startRefreshAuthFlow()
    }
}

struct EmptyResponse: Decodable, Equatable {}
