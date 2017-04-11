//
//  ProfileViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/11.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    enum Gender: Int {

        case male, female

    }

    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var nicknameTextField: UITextField!

    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!

    @IBOutlet weak var ageTextField: UITextField!

    @IBAction func genderChanged(_ sender: UISegmentedControl) {

        if genderSegmentedControl.selectedSegmentIndex == Gender.male.rawValue {

            profileImageView.image = #imageLiteral(resourceName: "poo-icon")

        } else {

            profileImageView.image = UIImage(named: "")

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Palette.backgoundColor

        profileImageView.backgroundColor = UIColor.lightGray
        profileImageView.image = #imageLiteral(resourceName: "poo-icon")

        nicknameTextField.delegate = self
        nicknameTextField.clearButtonMode = .whileEditing
        nicknameTextField.placeholder = "Nickname"
        nicknameTextField.clearsOnBeginEditing = true
        nicknameTextField.keyboardType = .alphabet
        nicknameTextField.returnKeyType = .done

        genderSegmentedControl.selectedSegmentIndex = Gender.male.rawValue
        genderSegmentedControl.setTitle("Male", forSegmentAt: Gender.male.rawValue)
        genderSegmentedControl.setTitle("Female", forSegmentAt: Gender.female.rawValue)

        ageTextField.delegate = self
        ageTextField.clearButtonMode = .whileEditing
        ageTextField.placeholder = "Age"
        ageTextField.clearsOnBeginEditing = true
        ageTextField.keyboardType = .numberPad
        ageTextField.returnKeyType = .done

        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
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

        if textField == ageTextField {

            self.view.bounds = CGRect(x: 0, y: 250, width: self.view.frame.size.width, height: self.view.frame.size.height)

        }

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {

        self.view.bounds = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)

    }

}
