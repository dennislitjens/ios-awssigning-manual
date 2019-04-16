//
//  ServiceAssembly.swift
//  ManualAwsSigningExample
//
//  Created by Dennis Litjens on 16/04/2019.
//  Copyright © 2019 AppFoundry. All rights reserved.
//

import Swinject

class ServiceAssembly: Assembly {

    func assemble(container: Container) {
        container.register(UserService.self, factory: self.createUserService)
            .inObjectScope(.container)
        container.register(UserDefaultsService.self, factory: self.createUserDefaultsService)
    }

    func createUserService(resolver: Resolver) -> UserService {
        let slackConfig = resolver.resolve(SlackConfig.self)!
        let networkManager = resolver.resolve(NetworkManager.self)!
        let userDefaultsService = resolver.resolve(UserDefaultsService.self)!
        return UserService(
            slackUrlParameters: slackConfig.slackUrlParameters,
            networkManager: networkManager,
            userDefaultsService: userDefaultsService
        )
    }

    func createUserDefaultsService(resolver: Resolver) -> UserDefaultsService {
        return UserDefaultsService()
    }
}

