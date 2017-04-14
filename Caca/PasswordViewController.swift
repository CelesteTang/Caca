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

        print(UserDefaults.standard.string(forKey: "Password"))

        if UserDefaults.standard.bool(forKey: "TouchIDAuthentication") == true {

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

        view.backgroundColor = Palette.backgoundColor
        passwordLabel.text = "Please enter your password"

        passwordField.delegate = self
        passwordField.clearButtonMode = .never
        passwordField.placeholder = "Password"
        passwordField.textAlignment = .center
        passwordField.clearsOnBeginEditing = true
        passwordField.isSecureTextEntry = true
        passwordField.returnKeyType = .done

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
                    title: "Alert",
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
