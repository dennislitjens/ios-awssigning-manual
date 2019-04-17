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
import RxSwift
import RxCocoa
import AWSMobileClient

class SigninViewController: UIViewController {

    @IBOutlet var signinButton: LoadingButton! {
        didSet {
            if AWSMobileClient.sharedInstance().isSignedIn {
                self.signinButton.setTitle("Sign out", for: .normal)
            } else {
                self.signinButton.setTitle("Signin with slack", for: .normal)
            }
        }
    }
    
    @IBOutlet var callButton: UIButton! {
        didSet {
            self.callButton.isEnabled = AWSMobileClient.sharedInstance().isSignedIn
        }
    }
    
    @IBOutlet var signedinStatusLabel: UILabel! {
        didSet {
            if AWSMobileClient.sharedInstance().isSignedIn {
                self.signedinStatusLabel.text = "Signed in successfully!"
                self.signedinStatusLabel.textColor = UIColor.green
            } else {
                self.signedinStatusLabel.text = "Not signed in"
                self.signedinStatusLabel.textColor = UIColor.red
            }
        }
    }
    var userService: UserService!
    var networkManager: NetworkManager!
    private let disposeBag = DisposeBag()

    private var loginSuccess = BehaviorSubject<Bool>(value: false)
    internal var loginSuccessDriver: Driver<Bool> {
        return loginSuccess.asDriver(onErrorJustReturn: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loginSuccessDriver
            .asObservable()
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.loginSuccessActions()
            }).disposed(by: self.disposeBag)
    }

    func startAuthFlow(with slackCode: String) {
        self.signinButton.showLoading()
        self.userService.startAuthFlow(slackCode: slackCode)
            .subscribe(onSuccess: { [weak self] _ in
                self?.loginSuccess.onNext(true)
                }, onError: {
                    os_log("AuthFlow error: %@", type: .error, $0.localizedDescription)
            }).disposed(by: self.disposeBag)
    }

    //MARK: Actions

    @IBAction func signinWithSlack(_ sender: Any) {
        if !AWSMobileClient.sharedInstance().isSignedIn {
            self.userService.openSlackAuthUrl()
        } else {
            AWSMobileClient.sharedInstance().signOut()
            self.signedinStatusLabel.text = "Not signed in"
            self.signedinStatusLabel.textColor = UIColor.red
            self.signinButton.setTitle("Sign in with slack", for: .normal)
            self.callButton.isEnabled = false
        }
    }
    
    @IBAction func makeSignedCall(_ sender: Any) {
        do {
            try self.networkManager.fetchLocationEntries()
                .asObservable()
                .subscribe(onNext: { response in
                    self.showToast(with: "Call succeeded")
                    response.forEach {
                        print($0)
                    }
                }, onError: {
                    self.showToast(with: "Call error: \($0.localizedDescription)")
                    os_log("Call error: %@", type: .error, $0.localizedDescription)
                }).disposed(by: self.disposeBag)
        } catch {
            self.showToast(with: "Call error: \(error.localizedDescription)")
            os_log("Call error: %@", type: .error, error.localizedDescription)
        }
    }

    private func loginSuccessActions() {
        self.signedinStatusLabel.text = "Signed in successfully!"
        self.signinButton.hideLoading()
        self.signinButton.setTitle("Sign out", for: .normal)
        self.signedinStatusLabel.textColor = UIColor.green
        self.callButton.isEnabled = true
    }

    private func loginError() {
        self.signedinStatusLabel.text = "Something went wrong with login. Try again."
        self.signedinStatusLabel.textColor = UIColor.red
        self.signinButton.hideLoading()
    }
}

