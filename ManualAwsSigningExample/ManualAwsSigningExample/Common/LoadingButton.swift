//
//  LoadingButton.swift
//  ManualAwsSigningExample
//
//  Created by Dennis Litjens on 16/04/2019.
//  Copyright © 2019 AppFoundry. All rights reserved.
//

import UIKit

class LoadingButton: UIButton {
    var buttonText: String?
    var attributedString: NSAttributedString?
    var activityIndicator: UIActivityIndicatorView!

    func showLoading() {
        self.buttonText = self.titleLabel?.text
        self.attributedString = self.titleLabel?.attributedText
        self.setTitle("", for: .normal)
        self.setAttributedTitle(NSAttributedString(string: ""), for: .normal)

        if activityIndicator == nil {
            activityIndicator = createActivityIndicator()
        }

        showSpinning()
    }

    func hideLoading() {
        if activityIndicator != nil {
            self.setTitle(self.buttonText, for: .normal)
            self.setAttributedTitle(self.attributedString, for: .normal)
            activityIndicator.stopAnimating()
        }
    }

    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }

    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }

    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(
            item: self,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: activityIndicator,
            attribute: .centerX,
            multiplier: 1,
            constant: 0
        )
        self.addConstraint(xCenterConstraint)

        let yCenterConstraint = NSLayoutConstraint(
            item: self,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: activityIndicator,
            attribute: .centerY,
            multiplier: 1,
            constant: 0
        )
        self.addConstraint(yCenterConstraint)
    }
}
