//
//  ProfileViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/11.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var nicknameTextField: UITextField!

    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!

    @IBOutlet weak var ageTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()

        if let name = UserDefaults.standard.value(forKey: "Name") as? String {

            self.nicknameTextField.text = name

        }

        guard let gender = UserDefaults.standard.value(forKey: "Gender") as? Int else { return }
        self.genderSegmentedControl.selectedSegmentIndex = gender
        self.genderSegmentedControl.setTitle("Male", forSegmentAt: Gender.male.rawValue)
        self.genderSegmentedControl.setTitle("Female", forSegmentAt: Gender.female.rawValue)
        self.genderSegmentedControl.tintColor = Palette.textColor

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

        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)

        tabBarController?.tabBar.isHidden = true

    }

    // MARK: Set Up

    private func setUp() {

        navigationItem.title = "Profile"

        view.backgroundColor = Palette.backgoundColor

        self.profileImageView.backgroundColor = Palette.backgoundColor
        self.profileImageView.image = #imageLiteral(resourceName: "poo-icon")

        self.nicknameTextField.delegate = self
        self.nicknameTextField.clearButtonMode = .whileEditing
        self.nicknameTextField.placeholder = "Name"
        self.nicknameTextField.textAlignment = .center
        self.nicknameTextField.clearsOnBeginEditing = true
        self.nicknameTextField.keyboardType = .alphabet
        self.nicknameTextField.returnKeyType = .done

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        tabBarController?.tabBar.isHidden = false
        UserDefaults.standard.set(nicknameTextField.text, forKey: "Name")
        UserDefaults.standard.set(genderSegmentedControl.selectedSegmentIndex, forKey: "Gender")
        UserDefaults.standard.set(ageTextField.text, forKey: "Age")

    }

    func hideKeyBoard() {

        self.nicknameTextField.resignFirstResponder()
        self.ageTextField.resignFirstResponder()
    }

}

extension ProfileViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)

        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        if textField == nicknameTextField {

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
