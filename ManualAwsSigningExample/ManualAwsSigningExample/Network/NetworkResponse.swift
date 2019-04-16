//
//  NetworkResponse.swift
//  ManualAwsSigningExample
//
//  Created by Dennis Litjens on 15/04/2019.
//  Copyright © 2019 AppFoundry. All rights reserved.
//

import Foundation

protocol NetworkResponse {
    var response: HTTPURLResponse? { get }
    var description: String { get }
    var data: Data { get }
}

struct NetworkManagerResponse: Equatable, CustomStringConvertible, NetworkResponse {

    let response: HTTPURLResponse?
    let data: Data

    var description: String {
        return "NetworkManagerResponse: [URL:\(self.response?.url?.absoluteString ?? "-")]" +
        "[StatusCode:\(self.response?.statusCode ?? -1)"
    }
}

struct NetworkManagerResponseError: LocalizedError, NetworkResponse {

    let response: HTTPURLResponse?
    let data: Data
    let networkError: Error

    var errorDescription: String? {
        return "NetworkError: \(self.networkError.localizedDescription)"
    }

    var description: String {
        return "NetworkError: \(self.networkError.localizedDescription)"
    }
}
