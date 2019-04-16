//
//  SlackAuthTokens.swift
//  ManualAwsSigningExample
//
//  Created by Dennis Litjens on 15/04/2019.
//  Copyright © 2019 AppFoundry. All rights reserved.
//

import Foundation

struct SlackAuthTokens: Codable {
    let accessToken: String
    let scope: String
}

extension SlackAuthTokens {
    private enum SlackAuthTokensCodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case scope
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SlackAuthTokensCodingKeys.self)
        self.accessToken = try container.decode(String.self, forKey: .accessToken)
        self.scope = try container.decode(String.self, forKey: .scope)
    }
}
