//
//  SigningAdapter.swift
//  ManualAwsSigningExample
//
//  Created by Dennis Litjens on 15/04/2019.
//  Copyright © 2019 AppFoundry. All rights reserved.
//

import Alamofire
import os.log

class AwsSigningAdapter: RequestAdapter {

    private let requestSigner: SignRequest
    private let urlThatNeedsSigning: String

    init(requestSigner: SignRequest, urlThatNeedsSigning: String) {
        self.requestSigner = requestSigner
        self.urlThatNeedsSigning = urlThatNeedsSigning
    }

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        if let url = urlRequest.url, url.absoluteString.contains(urlThatNeedsSigning) {
            if let signedRequest = self.requestSigner.signRequest(request: urlRequest) {
                return signedRequest
            } else {
                os_log("\nCould not sign request.", type: .error)
                throw AWSError.awsSigningError
            }
        } else {
            return urlRequest
        }
    }
}
