//
//  AppDelegate.swift
//  ManualAwsSigningExample
//
//  Created by Dennis Litjens on 15/04/2019.
//  Copyright © 2019 AppFoundry. All rights reserved.
//

import UIKit
import Swinject

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private let container = Container { container in
        let swinjectResolver = SwinjectResolver(container: container)
        swinjectResolver.assemble()
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        window.rootViewController = self.container.resolve(SigninViewController.self)!
        self.window = window

        return true
    }
}

