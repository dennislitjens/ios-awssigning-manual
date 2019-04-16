//
//  Config.swift
//  ManualAwsSigningExample
//
//  Created by Dennis Litjens on 16/04/2019.
//  Copyright © 2019 AppFoundry. All rights reserved.
//

import Foundation

struct Config {
    let baseURL: URL
}

extension Config: Decodable {

    struct InvalidURLError: Swift.Error {}

    enum CodingKeys: CodingKey {
        case baseURL
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawBaseURL = try container.decode(String.self, forKey: .baseURL)

        guard let baseURL = URL(string: rawBaseURL) else {
                throw InvalidURLError()
        }

        self.baseURL = baseURL
    }
}

