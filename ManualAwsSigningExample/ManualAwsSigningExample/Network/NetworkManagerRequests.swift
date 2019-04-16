//
//  NetworkManagerRequests.swift
//  ManualAwsSigningExample
//
//  Created by Dennis Litjens on 15/04/2019.
//  Copyright © 2019 AppFoundry. All rights reserved.
//

import Foundation

struct NetworkManagerRequests {

    private let baseURL: URL
    private let slackAuthTokenBaseURL: URL

    init(baseURL: URL, slackAuthTokenBaseURL: URL) {
        self.baseURL = baseURL
        self.slackAuthTokenBaseURL = slackAuthTokenBaseURL
    }

    func fetchLocationEntriesRequest() -> URLRequest {
        return self.request(
            baseURL: self.baseURL,
            path: "/locations",
            method: .get
        )
    }

    func fetchCognitoAuthToken(with slackToken: String) throws -> URLRequest {
        return self.request(
            baseURL: self.baseURL,
            path: "/auth",
            method: .post,
            body: try HTTP.Body(json: ["accessToken": slackToken])
        )
    }

    func fetchSlackAuthorizationToken(
        clientId: String,
        clientSecret: String,
        code: String,
        redirectUri: String
        ) throws -> URLRequest {
        return self.request(
            baseURL: self.slackAuthTokenBaseURL,
            path: "/oauth.access",
            method: .post,
            body: HTTP.Body(urlEncoded: [
                ("code", code),
                ("client_id", clientId),
                ("client_secret", clientSecret),
                ("redirect_uri", redirectUri)
                ])
        )
    }

    func updateUserLocation(with location: String) -> URLRequest {
        return self.request(
            baseURL: self.baseURL,
            path: "/locations/users/current/updateLocation",
            method: .put,
            body: HTTP.Body(urlEncoded: [
                ("lastLocation", location)
                ])
        )
    }

    private func request(
        baseURL: URL,
        path: String?,
        method: HTTP.Method,
        body: HTTP.Body? = nil,
        headers: HTTP.Headers = [:]
        ) -> URLRequest {
        var request = URLRequest(url: path.map { baseURL.appendingPathComponent($0) } ?? baseURL)
        request.httpMethod = method.rawValue

        body.map {
            request.httpBody = $0.data
            if let headerValue = $0.contentType.httpHeaderValue {
                request.allHTTPHeaderFields?["Content-Type"] = headerValue
            }
        }

        return request
    }
}
