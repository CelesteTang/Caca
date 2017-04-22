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

    var isFromProfile = false

    var isFromStart = false

    @IBOutlet weak var logoImageView: UIImageView!

    @IBOutlet weak var appName: UILabel!

    @IBOutlet weak var emailField: UITextField!

    @IBOutlet weak var passwordField: UITextField!

    @IBOutlet weak var nameField: UITextField!

    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!

    @IBOutlet weak var signUpButton: UIButton!

    @IBOutlet weak var cancelButton: UIButton!

    @IBAction func cancelSignUp(_ sender: UIButton) {

        if isFromStart == true {

            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.window?.rootViewController = UIStoryboard(name: "Landing", bundle: nil).instantiateViewController(withIdentifier: "StartViewController") as? StartViewController
            }

            isFromStart = false

        } else if isFromProfile == true {

            dismiss(animated: true, completion: nil)

            isFromProfile = false

        }

    }

    @IBAction func signUp(_ sender: UIButton) {

        if self.emailField.text == "" {

            let alertController = UIAlertController(title: "Warning",
                                                    message: "Please enter your email",
                                                    preferredStyle: UIAlertControllerStyle.alert)

            alertController.addAction(UIAlertAction(title: "OK",
                                                    style: UIAlertActionStyle.default,
                                                    handler: nil))

            self.present(alertController, animated: true, completion: nil)

        } else if self.passwordField.text == "" {

            let alertController = UIAlertController(title: "Warning",
                                                    message: "Please enter your password",
                                                    preferredStyle: UIAlertControllerStyle.alert)

            alertController.addAction(UIAlertAction(title: "OK",
                                                    style: UIAlertActionStyle.default,
                                                    handler: nil))

            self.present(alertController, animated: true, completion: nil)

        } else if self.nameField.text == "" {

            let alertController = UIAlertController(title: "Warning",
                                                    message: "Please enter your name",
                                                    preferredStyle: UIAlertControllerStyle.alert)

            alertController.addAction(UIAlertAction(title: "OK",
                                                    style: UIAlertActionStyle.default,
                                                    handler: nil))

            self.present(alertController, animated: true, completion: nil)

        } else {

            guard let email = emailField.text, let password = passwordField.text, let name = self.nameField.text else { return }

            let gender = self.genderSegmentedControl.selectedSegmentIndex

            if isFromStart == true {

                UserManager.shared.createUser(with: email, password: password, name: name, gender: gender, completion: { (createError, storageError) in

                    if let error = createError {

                        let alertController = UIAlertController(title: "Warning",
                                                                message: error.localizedDescription,
                                                                preferredStyle: .alert)

                        alertController.addAction(UIAlertAction(title: "OK",
                                                                style: .default,
                                                                handler: nil))

                        self.present(alertController, animated: true, completion: nil)

                    } else if let error = storageError {

                        let alertController = UIAlertController(title: "Warning",
                                                                message: error.localizedDescription,
                                                                preferredStyle: .alert)

                        alertController.addAction(UIAlertAction(title: "OK",
                                                                style: .default,
                                                                handler: nil))

                        self.present(alertController, animated: true, completion: nil)

                    } else if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.window?.rootViewController = UIStoryboard(name: "Opening", bundle: nil).instantiateViewController(withIdentifier: "OpeningPageViewController") as? OpeningPageViewController

                        UserDefaults.standard.set(name, forKey: "Name")
                        UserDefaults.standard.set(gender, forKey: "Gender")

                        self.isFromStart = false
                    }

                })

            } else if isFromProfile == true {

                UserManager.shared.linkUser(with: email, password: password, name: name, gender: gender, completion: { (createError, storageError) in

                    if let error = createError {

                        let alertController = UIAlertController(title: "Warning",
                                                                message: error.localizedDescription,
                                                                preferredStyle: .alert)

                        alertController.addAction(UIAlertAction(title: "OK",
                                                                style: .default,
                                                                handler: nil))

                        self.present(alertController, animated: true, completion: nil)

                    } else if let error = storageError {

                        let alertController = UIAlertController(title: "Warning",
                                                                message: error.localizedDescription,
                                                                preferredStyle: .alert)

                        alertController.addAction(UIAlertAction(title: "OK",
                                                                style: .default,
                                                                handler: nil))

                        self.present(alertController, animated: true, completion: nil)

                    } else if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.window?.rootViewController = UIStoryboard(name: "Opening", bundle: nil).instantiateViewController(withIdentifier: "OpeningPageViewController") as? OpeningPageViewController

                        UserDefaults.standard.set(name, forKey: "Name")
                        UserDefaults.standard.set(gender, forKey: "Gender")

                        self.isFromProfile = false
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

        self.cancelButton.setTitle("", for: .normal)
        let buttonimage = #imageLiteral(resourceName: "GoBack").withRenderingMode(.alwaysTemplate)
        self.cancelButton.setImage(buttonimage, for: .normal)
        self.cancelButton.tintColor = Palette.darkblue

        self.logoImageView.image = #imageLiteral(resourceName: "caca-big")
        self.logoImageView.backgroundColor = Palette.lightblue2

        self.appName.text = "Caca"
        self.appName.textColor = Palette.darkblue
        self.appName.font = UIFont(name: "Courier-Bold", size: 60)

        self.emailField.delegate = self
        self.emailField.clearButtonMode = .never
        self.emailField.placeholder = "Email"
        self.emailField.clearsOnBeginEditing = true
        self.emailField.keyboardType = .emailAddress
        self.emailField.returnKeyType = .done

        self.passwordField.delegate = self
        self.passwordField.clearButtonMode = .never
        self.passwordField.placeholder = "Password (at least 6 characters)"
        self.passwordField.clearsOnBeginEditing = true
        self.passwordField.isSecureTextEntry = true
        self.passwordField.returnKeyType = .done

        self.nameField.delegate = self
        self.nameField.clearButtonMode = .whileEditing
        self.nameField.placeholder = "Name"
        self.nameField.clearsOnBeginEditing = true
        self.nameField.returnKeyType = .done

        self.genderSegmentedControl.setTitle("Male", forSegmentAt: Gender.male.rawValue)
        self.genderSegmentedControl.setTitle("Female", forSegmentAt: Gender.female.rawValue)
        self.genderSegmentedControl.tintColor = Palette.darkblue

        self.signUpButton.backgroundColor = Palette.darkblue
        self.signUpButton.setTitle("Sign Up", for: .normal)
        self.signUpButton.layer.cornerRadius = 15
        self.signUpButton.tintColor = Palette.lightblue2

    }

}

extension SignUpViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)

        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        self.view.bounds = CGRect(x: 0, y: 250, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
//        if textField == self.emailField {
//            
//            self.view.bounds = CGRect(x: 0, y: 250, width: self.view.frame.size.width, height: self.view.frame.size.height)
//            
//        } else if textField == self.passwordField {
//            
//            self.view.bounds = CGRect(x: 0, y: 250, width: self.view.frame.size.width, height: self.view.frame.size.height)
//            
//        } else if textField == self.nameField {
//        
//            self.view.bounds = CGRect(x: 0, y: 250, width: self.view.frame.size.width, height: self.view.frame.size.height)
//
//        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.view.bounds = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
    }
}
