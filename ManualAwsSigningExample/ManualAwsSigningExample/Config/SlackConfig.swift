//
//  SlackConfig.swift
//  ManualAwsSigningExample
//
//  Created by Dennis Litjens on 16/04/2019.
//  Copyright © 2019 AppFoundry. All rights reserved.
//

import Foundation

struct SlackConfig {
    let slackAuthTokenBaseURL: URL
    let slackUrlParameters: SlackUrlParameters
}

extension SlackConfig: Decodable {

    struct InvalidURLError: Swift.Error {}

    enum CodingKeys: CodingKey {
        case slackScope
        case slackClientId
        case slackClientSecret
        case slackRedirectUri
        case slackAuthURL
        case slackTeamId
        case slackAuthTokenBaseURL
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let slackScope = try container.decode(String.self, forKey: .slackScope)
        let slackClientId = try container.decode(String.self, forKey: .slackClientId)
        let slackClientSecret = try container.decode(String.self, forKey: .slackClientSecret)
        let slackRedirectUri = try container.decode(String.self, forKey: .slackRedirectUri)
        let slackTeamId = try container.decode(String.self, forKey: .slackTeamId)

        let rawSlackAuthURL = try container.decode(String.self, forKey: .slackAuthURL)
        let slackAuthTokenRawBaseURL = try container.decode(String.self, forKey: .slackAuthTokenBaseURL)
        guard let slackAuthURL = URL(string: rawSlackAuthURL),
            let slackAuthTokenBaseURL = URL(string: slackAuthTokenRawBaseURL) else {
                throw InvalidURLError()
        }

        self.slackAuthTokenBaseURL = slackAuthTokenBaseURL
        self.slackUrlParameters = SlackUrlParameters(
            slackScope: slackScope,
            slackClientId: slackClientId,
            slackClientSecret: slackClientSecret,
            slackRedirectUri: slackRedirectUri,
            slackAuthURL: slackAuthURL,
            slackTeamId: slackTeamId
        )
    }
}

extension SlackConfig {
    struct SlackUrlParameters {
        let slackScope: String
        let slackClientId: String
        let slackClientSecret: String
        let slackRedirectUri: String
        let slackAuthURL: URL
        let slackTeamId: String
    }
}

