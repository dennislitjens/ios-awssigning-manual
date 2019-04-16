//
//  UIViewController+Toast.swift
//  ManualAwsSigningExample
//
//  Created by Dennis Litjens on 16/04/2019.
//  Copyright © 2019 AppFoundry. All rights reserved.
//

import UIKit

extension UIViewController {
    func showToast(with message: String) {
        let toastLabel = self.label

        toastLabel.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        toastLabel.textColor = UIColor.black
        toastLabel.textAlignment = .center
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0
        toastLabel.text = message

        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 4, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }

    private var label: PaddingLabel {
        let widthSuperView = self.view.frame.size.width
        let widthToastLabel = self.view.frame.size.width - 40
        return PaddingLabel(frame: CGRect(
            x: widthSuperView/2 - widthToastLabel/2,
            y: 30,
            width: widthToastLabel,
            height: 80)
        )
    }
}
