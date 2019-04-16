//
//  CognitoAuthTokens.swift
//  ManualAwsSigningExample
//
//  Created by Dennis Litjens on 15/04/2019.
//  Copyright © 2019 AppFoundry. All rights reserved.
//

struct CognitoAuthTokens {
    let identityId: String
    let token: String
    let expiresAt: Int
}

extension CognitoAuthTokens: Decodable {
    private enum CognitoAuthTokensCodingKeys: String, CodingKey {
        case identityId = "IdentityId"
        case token = "Token"
        case expiresAt = "ExpiresAt"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CognitoAuthTokensCodingKeys.self)
        self.identityId = try container.decode(String.self, forKey: .identityId)
        self.token = try container.decode(String.self, forKey: .token)
        self.expiresAt = try container.decode(Int.self, forKey: .expiresAt)
    }
}
