//
//  ProfileViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/11.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!

    @IBOutlet weak var ageTextField: UITextField!

    @IBOutlet weak var signUpButton: UIButton!

    @IBAction func signUp(_ sender: UIButton) {

        let signUpStorybard = UIStoryboard(name: "Landing", bundle: nil)
        guard let signUpViewController = signUpStorybard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else { return }

        signUpViewController.isFromProfile = true

        present(signUpViewController, animated: true)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()

        if let name = UserDefaults.standard.value(forKey: "Name") as? String {

            self.nameTextField.text = name

        }

        guard let gender = UserDefaults.standard.value(forKey: "Gender") as? Int else { return }
        self.genderSegmentedControl.selectedSegmentIndex = gender
        self.genderSegmentedControl.setTitle("Male", forSegmentAt: Gender.male.rawValue)
        self.genderSegmentedControl.setTitle("Female", forSegmentAt: Gender.female.rawValue)
        self.genderSegmentedControl.tintColor = Palette.darkblue
        self.genderSegmentedControl.addTarget(self, action: #selector(changeGender), for: .valueChanged)
        if gender == Gender.male.rawValue {

            self.profileImageView.image = #imageLiteral(resourceName: "boy")

        } else if gender == Gender.female.rawValue {

            self.profileImageView.image = #imageLiteral(resourceName: "girl")

        }

        self.ageTextField.delegate = self
        self.ageTextField.clearButtonMode = .whileEditing
        self.ageTextField.placeholder = "Age"
        self.ageTextField.textAlignment = .center
        self.ageTextField.clearsOnBeginEditing = true
        self.ageTextField.keyboardType = .numberPad
        self.ageTextField.returnKeyType = .done
        if let age = UserDefaults.standard.value(forKey: "Age") as? String {

            ageTextField.text = age

        }

        self.signUpButton.backgroundColor = Palette.darkblue
        self.signUpButton.setTitle("Sign Up", for: .normal)
        self.signUpButton.layer.cornerRadius = 15
        self.signUpButton.tintColor = Palette.lightblue2
        let user = FIRAuth.auth()?.currentUser
        if user?.isAnonymous == true {

            signUpButton.isHidden = false

        } else {

            signUpButton.isHidden = true
            signUpButton.isEnabled = false

        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)

    }

    // MARK: Set Up

    private func setUp() {

        navigationItem.title = "Profile"

        view.backgroundColor = Palette.lightblue2

        self.profileImageView.backgroundColor = Palette.lightblue2

        self.nameTextField.delegate = self
        self.nameTextField.clearButtonMode = .whileEditing
        self.nameTextField.placeholder = "Name"
        self.nameTextField.textAlignment = .center
        self.nameTextField.clearsOnBeginEditing = true
        self.nameTextField.keyboardType = .alphabet
        self.nameTextField.returnKeyType = .done

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.isHidden = true

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        tabBarController?.tabBar.isHidden = false

        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        let value = ["name": nameTextField.text,
                     "gender": genderSegmentedControl.selectedSegmentIndex,
                     "age": ageTextField.text] as [String: Any]

        UserManager.shared.editUser(with: uid, value: value)

        UserDefaults.standard.set(nameTextField.text, forKey: "Name")
        UserDefaults.standard.set(genderSegmentedControl.selectedSegmentIndex, forKey: "Gender")
        UserDefaults.standard.set(ageTextField.text, forKey: "Age")

    }

    func hideKeyBoard() {

        self.nameTextField.resignFirstResponder()
        self.ageTextField.resignFirstResponder()
    }

    func changeGender() {

        if self.genderSegmentedControl.selectedSegmentIndex == Gender.male.rawValue {

            self.profileImageView.image = #imageLiteral(resourceName: "boy")

        } else if self.genderSegmentedControl.selectedSegmentIndex == Gender.female.rawValue {

            self.profileImageView.image = #imageLiteral(resourceName: "girl")

        }

    }

}

extension ProfileViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)

        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        if textField == nameTextField {

            self.view.bounds = CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: self.view.frame.size.height)

        } else if textField == ageTextField {

            self.view.bounds = CGRect(x: 0, y: 200, width: self.view.frame.size.width, height: self.view.frame.size.height)

        }

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {

        self.view.bounds = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)

    }

}
