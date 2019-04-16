//
//  NetworkSession.swift
//  ManualAwsSigningExample
//
//  Created by Dennis Litjens on 15/04/2019.
//  Copyright © 2019 AppFoundry. All rights reserved.
//

import Alamofire

protocol NetworkSession {
    func perform(request: URLRequest) throws -> NetworkResponse
}

extension SessionManager: NetworkSession {
    func perform(request: URLRequest) throws -> NetworkResponse {
        var networkResponse: NetworkResponse?
            self.request(request)
                .validate()
                .responseData(completionHandler: { response in
                    switch response.result {
                    case .success(let data):
                        networkResponse = NetworkManagerResponse(
                            response: response.response,
                            data: data
                        )
                    case .failure(let error):
                        networkResponse = NetworkManagerResponseError(
                            response: response.response,
                            data: response.data ?? Data(),
                            networkError: error
                        )
                    }
                })
        if let response = networkResponse {
            return response
        } else {
            throw NetworkError.noResponseError
        }
    }
}
