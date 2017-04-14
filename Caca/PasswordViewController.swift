//
//  PasswordViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/6.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit
import LocalAuthentication

class PasswordViewController: UIViewController {

    @IBOutlet weak var passwordLabel: UILabel!

    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()

        if UserDefaults.standard.bool(forKey: "TouchIDAuthentication") == true && UserDefaults.standard.string(forKey: "Password") != nil {

            let context = LAContext()

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {

                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Use TouchID to enter Caca", reply: { (success, _) in

                    if success {
                        DispatchQueue.main.async {

                            if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? TabBarController {

                                appDelegate.window?.rootViewController = tabBarController

                            }
                        }
                    }

                })

            }
        }

    }

    // MARK: Set Up

    private func setUp() {

        self.view.backgroundColor = Palette.backgoundColor
        self.passwordLabel.text = "Please enter your password"

        self.passwordField.delegate = self
        self.passwordField.clearButtonMode = .never
        self.passwordField.placeholder = "Password"
        self.passwordField.textAlignment = .center
        self.passwordField.clearsOnBeginEditing = true
        self.passwordField.isSecureTextEntry = true
        self.passwordField.returnKeyType = .done

    }
}

extension PasswordViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)

        if UserDefaults.standard.string(forKey: "Password") == nil {

            UserDefaults.standard.set(passwordField.text, forKey: "Password")

            dismiss(animated: true, completion: nil)

        } else {

            if passwordField.text == UserDefaults.standard.value(forKey: "Password") as? String {

                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.window?.rootViewController = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? TabBarController

                }

            } else {

                let alertController = UIAlertController(
                    title: "Warning",
                    message: "The password is incorrect. Try again.",
                    preferredStyle: .alert)

                let okAction = UIAlertAction(
                    title: "OK",
                    style: .default,
                    handler: nil)

                alertController.addAction(okAction)

                self.present(
                    alertController,
                    animated: true,
                    completion: nil)
            }
        }

        return true
    }
}
