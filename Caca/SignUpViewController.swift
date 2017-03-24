//
//  SignUpViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/24.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!

    @IBOutlet weak var appName: UILabel!

    @IBOutlet weak var emailField: UITextField!

    @IBOutlet weak var passwordField: UITextField!

    @IBOutlet weak var firstNameField: UITextField!

    @IBOutlet weak var lastNameField: UITextField!

    @IBOutlet weak var signUpButton: UIButton!

    @IBAction func signUp(_ sender: UIButton) {

        if self.firstNameField.text == "" {

            let alertController = UIAlertController(title: "Warning",
                                                    message: "Please enter your first name",
                                                    preferredStyle: UIAlertControllerStyle.alert)

            alertController.addAction(UIAlertAction(title: "OK",
                                                    style: UIAlertActionStyle.default,
                                                    handler: nil))

            self.present(alertController, animated: true, completion: nil)

        } else if self.lastNameField.text == "" {

            let alertController = UIAlertController(title: "Warning",
                                                    message: "Please enter your last name",
                                                    preferredStyle: UIAlertControllerStyle.alert)

            alertController.addAction(UIAlertAction(title: "OK",
                                                    style: UIAlertActionStyle.default,
                                                    handler: nil))

            self.present(alertController, animated: true, completion: nil)

        } else {

            if let email = emailField.text, let password = passwordField.text {

                FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in

                    if let error = error {

                        print("-SignUp----------\(error)")

                        return

                    } else {

                        guard let uid = user?.uid else { return }

                        let rootRef = FIRDatabase.database().reference()

                        let userRef = rootRef.child("users").child(uid)

                        let value = ["firstName": self.firstNameField.text,
                                     "lastName": self.lastNameField.text]

                        userRef.updateChildValues(value, withCompletionBlock: { (error, _) in
                            if error != nil {

                                print(error?.localizedDescription ?? "")

                                return
                            }
                        })
                    }

                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.window?.rootViewController = UIStoryboard(name: "Opening", bundle: nil).instantiateViewController(withIdentifier: "OpeningViewController") as? OpeningViewController
                    }
                })
            }
        }

    }

    @IBAction func switchToSignIn(_ sender: UIButton) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController = UIStoryboard(name: "Landing", bundle: nil).instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Palette.backgoundColor
        logoImageView.image = #imageLiteral(resourceName: "poo-icon")
        logoImageView.backgroundColor = Palette.backgoundColor
        signUpButton.backgroundColor = Palette.textColor

        appName.text = "Caca"
        appName.textColor = Palette.textColor
        appName.font = UIFont(name: "Courier-Bold", size: 60)

        emailField.clearButtonMode = .whileEditing
        passwordField.clearButtonMode = .whileEditing
        passwordField.isSecureTextEntry = true
        firstNameField.clearButtonMode = .whileEditing
        lastNameField.clearButtonMode = .whileEditing
    }

}
