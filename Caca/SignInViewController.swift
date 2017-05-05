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

    @IBOutlet weak var goBackButton: UIButton!

    @IBAction func goBack(_ sender: UIButton) {

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

            let startViewController = UIStoryboard(name: Constants.Storyboard.landing, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.start) as? StartViewController

            appDelegate.window?.rootViewController = startViewController

        }
    }

    @IBAction func signIn(_ sender: UIButton) {

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

        } else if let email = self.emailField.text, let password = self.passwordField.text {

            // MARK : User log in

            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (_, error) in

                if let error = error {

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

                        UserDefaults.standard.set(true, forKey: Constants.UserDefaultsKey.isViewedWalkThrough)

                        appDelegate.window?.rootViewController = tabBarController

                    }
                }
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()

    }

    // MARK: Set Up

    private func setUp() {

        self.view.backgroundColor = Palette.lightblue2

        self.goBackButton.setTitle("", for: .normal)
        let buttonimage = #imageLiteral(resourceName: "goBack").withRenderingMode(.alwaysTemplate)
        self.goBackButton.setImage(buttonimage, for: .normal)
        self.goBackButton.tintColor = Palette.darkblue

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

        self.signInButton.backgroundColor = Palette.darkblue2
        self.signInButton.setTitle(NSLocalizedString("Log In", comment: ""), for: .normal)
        self.signInButton.layer.cornerRadius = self.signInButton.frame.height / 2
        self.signInButton.tintColor = Palette.cream
        self.signInButton.titleLabel?.font = UIFont(name: Constants.UIFont.futuraBold, size: 20)

        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)

    }

    func hideKeyBoard() {

        self.view.endEditing(true)

        self.view.bounds = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)

    }
}

extension SignInViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        self.view.endEditing(true)

        self.view.bounds = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
       
        if textField == emailField {

            self.view.bounds = CGRect(x: 0, y: 250, width: self.view.frame.size.width, height: self.view.frame.size.height)

        } else if textField == passwordField {

            self.view.bounds = CGRect(x: 0, y: 200, width: self.view.frame.size.width, height: self.view.frame.size.height)

        }

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {

        if textField == emailField && passwordField.isTouchInside {
        
            self.view.bounds = CGRect(x: 0, y: 200, width: self.view.frame.size.width, height: self.view.frame.size.height)

        } else if textField == passwordField && emailField.isTouchInside {
        
            self.view.bounds = CGRect(x: 0, y: 250, width: self.view.frame.size.width, height: self.view.frame.size.height)

        } else if textField == emailField || textField == passwordField {
        
            self.view.bounds = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)

        }
        
    }

}
