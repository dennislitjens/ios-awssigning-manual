//
//  NetworkAssembly.swift
//  ManualAwsSigningExample
//
//  Created by Dennis Litjens on 16/04/2019.
//  Copyright © 2019 AppFoundry. All rights reserved.
//

import Swinject
import Alamofire

class NetworkAssembly: SessionDelegate, Assembly {

    func assemble(container: Container) {
        container.register(NetworkManager.self, factory: self.createNetworkManager)
            .inObjectScope(.container)
        container.register(NetworkSession.self, factory: self.createSessionManager)
            .inObjectScope(.container)
        container.register(NetworkManagerRequests.self, factory: self.createNetworkManagerRequests)
            .inObjectScope(.container)
        container.register(SignRequest.self, factory: self.createSignRequest)
            .inObjectScope(.container)
        container.register(AwsSigningAdapter.self, factory: self.createAwsSigningAdapter)
            .inObjectScope(.container)
        container.register(Config.self, factory: self.createConfig)
            .inObjectScope(.container)
        container.register(SlackConfig.self, factory: self.createSlackConfig)
            .inObjectScope(.container)
    }

    func createNetworkManager(resolver: Resolver) -> NetworkManager {
        let sessionManager = resolver.resolve(NetworkSession.self)!
        let requests = resolver.resolve(NetworkManagerRequests.self)!
        let userDefaultsService = resolver.resolve(UserDefaultsService.self)!
        let slackConfig = resolver.resolve(SlackConfig.self)!
        let networkManager = NetworkManager(
            session: sessionManager,
            requests: requests
        )
        let userService = UserService(
            slackUrlParameters: slackConfig.slackUrlParameters,
            networkManager: networkManager,
            userDefaultsService: userDefaultsService
        )
        networkManager.userService = userService
        return networkManager
    }

    func createSessionManager(resolver: Resolver) -> NetworkSession {
        let configuration = URLSessionConfiguration.default

        let sessionManager = SessionManager(configuration: configuration, delegate: self, serverTrustPolicyManager: nil)
        sessionManager.adapter = resolver.resolve(AwsSigningAdapter.self)!
        return sessionManager
    }

    func createNetworkManagerRequests(resolver: Resolver) -> NetworkManagerRequests {
        let config = resolver.resolve(Config.self)!
        let slackConfig = resolver.resolve(SlackConfig.self)!
        return NetworkManagerRequests(baseURL: config.baseURL, slackAuthTokenBaseURL: slackConfig.slackAuthTokenBaseURL)
    }

    func createSignRequest(resolver: Resolver) -> SignRequest {
        let userDefaultsService = resolver.resolve(UserDefaultsService.self)!
        let requestSigner = URLRequestSigner()
        return SignRequest(userDefaultsService: userDefaultsService, requestSigner: requestSigner)
    }

    func createAwsSigningAdapter(resolver: Resolver) -> AwsSigningAdapter {
        let requestSigner = resolver.resolve(SignRequest.self)!
        let config = resolver.resolve(Config.self)!
        return AwsSigningAdapter(requestSigner: requestSigner, urlThatNeedsSigning: config.baseURL.absoluteString)
    }

    func createConfig(resolver: Resolver) -> Config {
        let configFile = Bundle.main.url(forResource: "Config", withExtension: "plist")!
        return try! PropertyListDecoder().decode(Config.self, from: Data(contentsOf: configFile))
    }

    func createSlackConfig(resolver: Resolver) -> SlackConfig {
        let slackConfigFile = Bundle.main.url(forResource: "SlackConfig", withExtension: "plist")!
        return try! PropertyListDecoder().decode(SlackConfig.self, from: Data(contentsOf: slackConfigFile))
    }

}

