//
//  UserDefaultsService.swift
//  ManualAwsSigningExample
//
//  Created by Dennis Litjens on 15/04/2019.
//  Copyright © 2019 AppFoundry. All rights reserved.
//

import Foundation
import os.log
import AWSMobileClient

class UserDefaultsService {

    private let slackAuthTokenKey = "be.docfoundry.slackToken"
    private let awsCredentialsKey = "be.docfoundry.awsCredentials"

    func saveAwsCredentials(awsCredentials: AwsCredentials) {
        do {
            let awsCredenialsData = try PropertyListEncoder().encode(awsCredentials)
            UserDefaults.standard.set(awsCredenialsData, forKey: awsCredentialsKey)
        } catch {
            os_log("\nAwsCredentials encoding error: %@", type: .error, String(describing: error))
        }
    }

    func getAwsCredentials() -> AwsCredentials? {
        do {
            if let awsCredentialsData = UserDefaults.standard.value(forKey: awsCredentialsKey) as? Data {
                let awsCredentials = try PropertyListDecoder().decode(AwsCredentials.self, from: awsCredentialsData)
                return awsCredentials
            }
        } catch {
            os_log("\nAwsCredentials decoding error: %@", type: .error, String(describing: error))
        }
        return nil
    }

    func removeAwsCredentials() {
        UserDefaults.standard.removeObject(forKey: awsCredentialsKey)
    }

    func saveSlackAuthToken(token: SlackAuthTokens) {
        do {
            let authTokenData = try PropertyListEncoder().encode(token)
            UserDefaults.standard.set(authTokenData, forKey: slackAuthTokenKey)
        } catch {
            os_log("\nSlackAuthToken encoding error: %@", type: .error, String(describing: error))
        }
    }

    func getSlackAuthToken() -> SlackAuthTokens? {
        do {
            if let slackAuthTokenData = UserDefaults.standard.value(forKey: slackAuthTokenKey) as? Data {
                let slackAuthToken = try PropertyListDecoder().decode(SlackAuthTokens.self, from: slackAuthTokenData)
                return slackAuthToken
            }
        } catch {
            os_log("\nSlackAuthToken decoding error: %@", type: .error, String(describing: error))
        }
        return nil
    }
}

