//
//  AppDelegate.swift
//  ManualAwsSigningExample
//
//  Created by Dennis Litjens on 15/04/2019.
//  Copyright © 2019 AppFoundry. All rights reserved.
//

import UIKit
import Swinject
import os.log

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var signinViewController: SigninViewController!

    private let container = Container { container in
        let swinjectResolver = SwinjectResolver(container: container)
        swinjectResolver.assemble()
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.signinViewController = self.container.resolve(SigninViewController.self)!
        window.rootViewController = self.signinViewController
        self.window = window

        return true
    }

    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems,
            let slackCode = queryItems[0].value {
            self.signinViewController.startAuthFlow(with: slackCode)
        }
        return true
    }
}

