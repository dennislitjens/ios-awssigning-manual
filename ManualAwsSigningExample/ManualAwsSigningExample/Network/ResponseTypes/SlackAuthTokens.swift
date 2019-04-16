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
