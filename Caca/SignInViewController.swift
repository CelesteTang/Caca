//
//  SignInViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/24.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!

    @IBOutlet weak var appName: UILabel!

    @IBOutlet weak var emailField: UITextField!

    @IBOutlet weak var passwordField: UITextField!

    @IBOutlet weak var signInButton: UIButton!

    @IBAction func signIn(_ sender: UIButton) {

        if let email = emailField.text, let password = passwordField.text {

            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (_, error) in

                if let error = error {

                    print("-SignIn---------\(error)")

                    let alertController = UIAlertController(title: "Warning",
                                                            message: "Incorrect email or password.",
                                                            preferredStyle: .alert)

                    alertController.addAction(UIAlertAction(title: "OK",
                                                            style: .default,
                                                            handler: nil))

                    self.present(alertController, animated: true, completion: nil)

                    return
                }

                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.window?.rootViewController = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? TabBarController
                }
            })
        }

    }

    @IBAction func switchToSignUp(_ sender: UIButton) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController = UIStoryboard(name: "Landing", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        
    }

    private func setUp() {
        
        view.backgroundColor = Palette.backgoundColor
        logoImageView.image = #imageLiteral(resourceName: "poo-icon")
        logoImageView.backgroundColor = Palette.backgoundColor
        signInButton.backgroundColor = Palette.textColor
        
        appName.text = "Caca"
        appName.textColor = Palette.textColor
        appName.font = UIFont(name: "Courier-Bold", size: 60)
        
        emailField.delegate = self
        emailField.clearButtonMode = .never
        emailField.placeholder = "Email"
        emailField.clearsOnBeginEditing = true
        emailField.keyboardType = .emailAddress
        emailField.returnKeyType = .done
        
        passwordField.delegate = self
        passwordField.clearButtonMode = .never
        passwordField.placeholder = "Password"
        passwordField.clearsOnBeginEditing = true
        passwordField.isSecureTextEntry = true
        passwordField.returnKeyType = .done
        
    }
}

extension SignInViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)

        return true
    }
}
