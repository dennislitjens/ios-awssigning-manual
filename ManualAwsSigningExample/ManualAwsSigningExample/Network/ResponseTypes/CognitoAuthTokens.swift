//
//  CognitoAuthTokens.swift
//  ManualAwsSigningExample
//
//  Created by Dennis Litjens on 15/04/2019.
//  Copyright © 2019 AppFoundry. All rights reserved.
//

struct CognitoAuthTokens: Codable {
    let identityId: String
    let token: String
    let expiresAt: Int
}
