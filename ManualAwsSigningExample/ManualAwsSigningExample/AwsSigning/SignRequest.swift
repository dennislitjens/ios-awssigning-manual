//
//  SignRequest.swift
//  ManualAwsSigningExample
//
//  Created by Dennis Litjens on 15/04/2019.
//  Copyright © 2019 AppFoundry. All rights reserved.
//

import Foundation
import AWSMobileClient
import os.log

struct SignRequest {
    private var userDefaultsService: UserDefaultsService
    private var requestSigner: URLRequestSigner

    init(userDefaultsService: UserDefaultsService, requestSigner: URLRequestSigner) {
        self.userDefaultsService = userDefaultsService
        self.requestSigner = requestSigner
    }

    func signRequest(request: URLRequest) -> URLRequest? {
        if let awsCredentials = self.userDefaultsService.getAwsCredentials() {
            return self.requestSigner.sign(
                request: request,
                secretSigningKey: awsCredentials.secretKey,
                accessKeyId: awsCredentials.accessKey,
                sessionId: awsCredentials.sessionKey
            )
        } else {
            os_log("\nNo AwsCredenials in UserDefaults error", type: .error)
            return nil
        }
    }
}
