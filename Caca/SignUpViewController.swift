//
//  SignUpViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/24.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit
import Firebase

enum Gender: Int {

    case male, female

}

class SignUpViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!

    @IBOutlet weak var appName: UILabel!

    @IBOutlet weak var emailField: UITextField!

    @IBOutlet weak var passwordField: UITextField!

    @IBOutlet weak var nameField: UITextField!

    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!

    @IBOutlet weak var signUpButton: UIButton!

    @IBAction func signUp(_ sender: UIButton) {

        if self.nameField.text == "" {

            let alertController = UIAlertController(title: "Warning",
                                                    message: "Please enter your name",
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

                        guard let name = self.nameField.text else { return }

                        let gender = self.genderSegmentedControl.selectedSegmentIndex

                        let value = ["name": name,
                                     "gender": gender] as [String: Any]

                        UserDefaults.standard.set(name, forKey: "Name")
                        UserDefaults.standard.set(gender, forKey: "Gender")

                        userRef.updateChildValues(value, withCompletionBlock: { (error, _) in

                            if error != nil {

                                print(error?.localizedDescription ?? "-SignUp---------Update error")

                                return
                            }
                        })
                    }

                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.window?.rootViewController = UIStoryboard(name: "Opening", bundle: nil).instantiateViewController(withIdentifier: "OpeningPageViewController") as? OpeningPageViewController
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

        setUp()

    }

    // MARK: Set Up

    private func setUp() {

        view.backgroundColor = Palette.backgoundColor
        logoImageView.image = #imageLiteral(resourceName: "poo-icon")
        logoImageView.backgroundColor = Palette.backgoundColor
        signUpButton.backgroundColor = Palette.textColor

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

        nameField.delegate = self
        nameField.clearButtonMode = .whileEditing
        nameField.placeholder = "First name"
        nameField.clearsOnBeginEditing = true
        nameField.returnKeyType = .done

        genderSegmentedControl.setTitle("Male", forSegmentAt: Gender.male.rawValue)
        genderSegmentedControl.setTitle("Female", forSegmentAt: Gender.female.rawValue)
        genderSegmentedControl.tintColor = Palette.textColor

    }

}

extension SignUpViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)

        return true
    }
}
