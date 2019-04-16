//
//  AwsCredentials.swift
//  ManualAwsSigningExample
//
//  Created by Dennis Litjens on 15/04/2019.
//  Copyright © 2019 AppFoundry. All rights reserved.
//

import Foundation

struct AwsCredentials: Codable {
    let accessKey: String
    let secretKey: String
    let sessionKey: String
}
