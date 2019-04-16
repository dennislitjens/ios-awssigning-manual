//
//  ControllerAssembly.swift
//  ManualAwsSigningExample
//
//  Created by Dennis Litjens on 16/04/2019.
//  Copyright © 2019 AppFoundry. All rights reserved.
//

import Swinject
import UIKit

class ControllerAssembly: Assembly {

    func assemble(container: Container) {
        container.register(SigninViewController.self, factory: self.createSigninViewController)
            .inObjectScope(.transient)
    }

    func createSigninViewController(_ resolver: Resolver) -> SigninViewController {
        let viewController = SigninViewController()
        viewController.userService = resolver.resolve(UserService.self)!
        viewController.networkManager = resolver.resolve(NetworkManager.self)!
        return viewController
    }
}
