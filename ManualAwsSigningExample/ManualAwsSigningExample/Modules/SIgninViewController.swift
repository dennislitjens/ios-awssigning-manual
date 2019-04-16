//
//  ViewController.swift
//  ManualAwsSigningExample
//
//  Created by Dennis Litjens on 15/04/2019.
//  Copyright © 2019 AppFoundry. All rights reserved.
//

import UIKit
import Foundation
import os.log

class SigninViewController: UIViewController {

    @IBOutlet var signinButton: LoadingButton!
    @IBOutlet var signedinStatusLabel: UILabel!
    var userService: UserService!
    var networkManager: NetworkManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func startAuthFlow(with slackCode: String) {
        self.signinButton.showLoading()
        do {
            try self.userService.startAuthFlow(slackCode: slackCode)
        } catch {
            self.signinButton.hideLoading()
            os_log("AuthFlow error: %@", type: .error, error.localizedDescription)
        }
    }

    //MARK: Actions

    @IBAction func signinWithSlack(_ sender: Any) {
        self.userService.openSlackAuthUrl()
    }
}

