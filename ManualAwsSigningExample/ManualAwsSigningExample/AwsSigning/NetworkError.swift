//
//  AwsError.swift
//  ManualAwsSigningExample
//
//  Created by Dennis Litjens on 15/04/2019.
//  Copyright © 2019 AppFoundry. All rights reserved.
//

import Foundation

enum AWSError: Error {
    case awsCredentialsFetchFail(Error)
    case awsFederatedSigninFail(Error)
    case awsSigningError
}

extension AWSError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .awsCredentialsFetchFail(let error):
            return "AWSCredentials fetch failed: \(error.localizedDescription)"
        case .awsFederatedSigninFail(let error):
            return "AWSCredentials federated signin failed: \(error.localizedDescription)"
        case .awsSigningError:
            return "AWS Signing failed."
        }
    }
}

enum NetworkError: Error {
    case noResponseError
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noResponseError:
            return "No response from api."
        }
    }
}
