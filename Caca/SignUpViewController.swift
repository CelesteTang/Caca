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

    @IBOutlet weak var genderField: UITextField!

    @IBOutlet weak var medicineField: UITextField!

    @IBOutlet weak var signUpButton: UIButton!

    @IBOutlet weak var cancelButton: UIButton!

    let genderPicker = UIPickerView()
    let medicinePicker = UIPickerView()

    let genders: [Gender] = [.male, .female, .personalReasons]
    let medicines: [Medicine] = [.yes, .no, .personalReasons]
    
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

        } else if self.genderField.text == "" {

            let alertController = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert to make user know something wrong happened"),
                                                    message: NSLocalizedString("Please enter your gender", comment: "User must enter gender"),
                                                    preferredStyle: UIAlertControllerStyle.alert)

            alertController.addAction(UIAlertAction(title: "OK",
                                                    style: UIAlertActionStyle.default,
                                                    handler: nil))

            self.present(alertController, animated: true, completion: nil)

        } else if self.medicineField.text == "" {

            let alertController = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert to make user know something wrong happened"),
                                                    message: NSLocalizedString("Please enter your medication", comment: "User must enter medication"),
                                                    preferredStyle: UIAlertControllerStyle.alert)

            alertController.addAction(UIAlertAction(title: "OK",
                                                    style: UIAlertActionStyle.default,
                                                    handler: nil))

            self.present(alertController, animated: true, completion: nil)

        } else {

            guard let email = self.emailField.text,
                  let password = self.passwordField.text,
                  let gender = self.genderField.text,
                  let medicine = self.medicineField.text else { return }
            
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
        self.emailField.clearButtonMode = .whileEditing
        self.emailField.placeholder = NSLocalizedString("Email", comment: "")
        self.emailField.keyboardType = .emailAddress
        self.emailField.returnKeyType = .done
        self.emailField.textColor = .black

        self.passwordField.delegate = self
        self.passwordField.clearButtonMode = .whileEditing
        self.passwordField.placeholder = NSLocalizedString("Password (at least 6 characters)", comment: "User must enter password containing at least 6 characters")
        self.passwordField.isSecureTextEntry = true
        self.passwordField.returnKeyType = .done
        self.passwordField.textColor = .black

        self.genderField.delegate = self
        self.genderField.clearButtonMode = .never
        self.genderField.placeholder = NSLocalizedString("Gender", comment: "")
        self.genderField.clearsOnBeginEditing = true
        self.genderField.inputView = self.genderPicker
        self.genderField.textColor = .black

        self.genderPicker.dataSource = self
        self.genderPicker.delegate = self

        self.medicineField.delegate = self
        self.medicineField.clearButtonMode = .never
        self.medicineField.placeholder = NSLocalizedString("On medication", comment: "")
        self.medicineField.clearsOnBeginEditing = true
        self.medicineField.inputView = self.medicinePicker
        self.medicineField.textColor = .black

        self.medicinePicker.dataSource = self
        self.medicinePicker.delegate = self
        
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

        self.view.bounds = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)

    }
}

extension SignUpViewController: UITextFieldDelegate {

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

        } else if textField == genderField {
            
            self.view.bounds = CGRect(x: 0, y: 200, width: self.view.frame.size.width, height: self.view.frame.size.height)
            
        } else if textField == medicineField {
            
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

extension SignUpViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {

        return 1

    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        switch pickerView {

        case genderPicker: return genders.count

        case medicinePicker: return medicines.count

        default: return 0

        }

    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        switch pickerView {

        case genderPicker:

            self.genderField.text = genders[row].title

        case medicinePicker:

            self.medicineField.text = medicines[row].title

        default: break

        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        let pickerLabel = UILabel()
        pickerLabel.font = UIFont(name: Constants.UIFont.futuraBold, size: 20)
        pickerLabel.textAlignment = NSTextAlignment.center

        switch pickerView {

        case genderPicker:

            pickerLabel.text = genders[row].title

            return pickerLabel

        case medicinePicker:

            pickerLabel.text = medicines[row].title

            return pickerLabel

        default:

            let view = UIView()

            view.isHidden = true

            return view

        }

    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {

        return 50.0
    }
}
