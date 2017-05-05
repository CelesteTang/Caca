//
//  SignUpViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/24.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit
import Firebase
import Crashlytics

class SignUpViewController: UIViewController {

    var isFromProfile = false

    var isFromStart = false

    @IBOutlet weak var logoImageView: UIImageView!

    @IBOutlet weak var appName: UILabel!

    @IBOutlet weak var emailField: UITextField!

    @IBOutlet weak var passwordField: UITextField!

    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!

    @IBOutlet weak var medicineSegmentedControl: UISegmentedControl!

    @IBOutlet weak var signUpButton: UIButton!

    @IBOutlet weak var cancelButton: UIButton!

    @IBAction func cancelSignUp(_ sender: UIButton) {

        if isFromStart == true {

            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

                let startViewController = UIStoryboard(name: Constants.Storyboard.landing, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.start) as? StartViewController

                appDelegate.window?.rootViewController = startViewController

            }

            isFromStart = false

        } else if isFromProfile == true {

            dismiss(animated: true, completion: nil)

            isFromProfile = false

        }

    }

    @IBAction func signUp(_ sender: UIButton) {

        if self.emailField.text == "" {

            let alertController = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert to make user know something wrong happened"),
                                                    message: NSLocalizedString("Please enter your email", comment: "User must enter email"),
                                                    preferredStyle: UIAlertControllerStyle.alert)

            alertController.addAction(UIAlertAction(title: "OK",
                                                    style: UIAlertActionStyle.default,
                                                    handler: nil))

            self.present(alertController, animated: true, completion: nil)

        } else if self.passwordField.text == "" {

            let alertController = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert to make user know something wrong happened"),
                                                    message: NSLocalizedString("Please enter your password", comment: "User must enter password"),
                                                    preferredStyle: UIAlertControllerStyle.alert)

            alertController.addAction(UIAlertAction(title: "OK",
                                                    style: UIAlertActionStyle.default,
                                                    handler: nil))

            self.present(alertController, animated: true, completion: nil)

        } else {

            guard let email = emailField.text, let password = passwordField.text else { return }

            let gender = self.genderSegmentedControl.selectedSegmentIndex
            let medicine = self.medicineSegmentedControl.selectedSegmentIndex

            if isFromStart == true {

                UserManager.shared.createUser(with: email, password: password, gender: gender, medicine: medicine, completion: { (createError, storageError) in

                    if let error = createError {

                        let alertController = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert to make user know something wrong happened"),
                                                                message: error.localizedDescription,
                                                                preferredStyle: .alert)

                        alertController.addAction(UIAlertAction(title: "OK",
                                                                style: .default,
                                                                handler: nil))

                        self.present(alertController, animated: true, completion: nil)

                    } else if let error = storageError {

                        let alertController = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert to make user know something wrong happened"),
                                                                message: error.localizedDescription,
                                                                preferredStyle: .alert)

                        alertController.addAction(UIAlertAction(title: "OK",
                                                                style: .default,
                                                                handler: nil))

                        self.present(alertController, animated: true, completion: nil)

                    } else {

                        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

                            let openingPageViewController = UIStoryboard(name: Constants.Storyboard.opening, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.openingPage) as? OpeningPageViewController

                            appDelegate.window?.rootViewController = openingPageViewController

                            self.isFromStart = false

                        }
                    }

                })

            } else if isFromProfile == true {

                // MARK : Link anonymous user to permanent account

                UserManager.shared.linkUser(with: email, password: password, gender: gender, medicine: medicine, completion: { (createError, storageError) in

                    if let error = createError {

                        let alertController = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert to make user know something wrong happened"),
                                                                message: error.localizedDescription,
                                                                preferredStyle: .alert)

                        alertController.addAction(UIAlertAction(title: "OK",
                                                                style: .default,
                                                                handler: nil))

                        self.present(alertController, animated: true, completion: nil)

                    } else if let error = storageError {

                        let alertController = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert to make user know something wrong happened"),
                                                                message: error.localizedDescription,
                                                                preferredStyle: .alert)

                        alertController.addAction(UIAlertAction(title: "OK",
                                                                style: .default,
                                                                handler: nil))

                        self.present(alertController, animated: true, completion: nil)

                    } else {

                        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

                            let tabBarController = UIStoryboard(name: Constants.Storyboard.tabBar, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.tabBar) as? TabBarController

                            appDelegate.window?.rootViewController = tabBarController

                            self.isFromProfile = false

                        }
                    }
                })
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()

    }

    // MARK: Set Up

    private func setUp() {

        self.view.backgroundColor = Palette.lightblue2

        if isFromStart == true {

            self.cancelButton.setTitle("", for: .normal)
            let buttonimage = #imageLiteral(resourceName: "goBack").withRenderingMode(.alwaysTemplate)
            self.cancelButton.setImage(buttonimage, for: .normal)
            self.cancelButton.tintColor = Palette.darkblue

        } else if isFromProfile == true {

            self.cancelButton.setTitle("", for: .normal)
            let buttonimage = #imageLiteral(resourceName: "cancel").withRenderingMode(.alwaysTemplate)
            self.cancelButton.setImage(buttonimage, for: .normal)
            self.cancelButton.tintColor = Palette.darkblue

        }

        self.logoImageView.image = #imageLiteral(resourceName: "caca-big")
        self.logoImageView.backgroundColor = Palette.lightblue2

        self.appName.text = "Caca"
        self.appName.textColor = Palette.darkblue2
        self.appName.font = UIFont(name: Constants.UIFont.futuraBold, size: 60)

        self.emailField.delegate = self
        self.emailField.clearButtonMode = .never
        self.emailField.placeholder = NSLocalizedString("Email", comment: "")
        self.emailField.clearsOnBeginEditing = true
        self.emailField.keyboardType = .emailAddress
        self.emailField.returnKeyType = .done

        self.passwordField.delegate = self
        self.passwordField.clearButtonMode = .never
        self.passwordField.placeholder = NSLocalizedString("Password (at least 6 characters)", comment: "User must enter password containing at least 6 characters")
        self.passwordField.clearsOnBeginEditing = true
        self.passwordField.isSecureTextEntry = true
        self.passwordField.returnKeyType = .done

        self.genderSegmentedControl.setImage(#imageLiteral(resourceName: "male"), forSegmentAt: Gender.male.rawValue)
        self.genderSegmentedControl.setImage(#imageLiteral(resourceName: "female"), forSegmentAt: Gender.female.rawValue)
        self.genderSegmentedControl.tintColor = Palette.darkblue2

        self.medicineSegmentedControl.setTitle("Yes", forSegmentAt: 0)
        self.medicineSegmentedControl.setTitle("No", forSegmentAt: 1)
//        self.medicineSegmentedControl.setImage(#imageLiteral(resourceName: "male"), forSegmentAt: Gender.male.rawValue)
//        self.medicineSegmentedControl.setImage(#imageLiteral(resourceName: "female"), forSegmentAt: Gender.female.rawValue)
        self.medicineSegmentedControl.tintColor = Palette.darkblue2

        self.signUpButton.backgroundColor = Palette.darkblue2
        self.signUpButton.setTitle(NSLocalizedString("Sign Up", comment: ""), for: .normal)
        self.signUpButton.layer.cornerRadius = self.signUpButton.frame.height / 2
        self.signUpButton.tintColor = Palette.cream
        self.signUpButton.titleLabel?.font = UIFont(name: Constants.UIFont.futuraBold, size: 20)

        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)

    }

    func hideKeyBoard() {

        self.view.endEditing(true)

    }
}

extension SignUpViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)

        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        self.view.bounds = CGRect(x: 0, y: 250, width: self.view.frame.size.width, height: self.view.frame.size.height)

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {

        self.view.bounds = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)

    }
}
