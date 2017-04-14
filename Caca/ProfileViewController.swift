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

            nicknameTextField.text = name

        }

        guard let gender = UserDefaults.standard.value(forKey: "Gender") as? Int else { return }
        genderSegmentedControl.selectedSegmentIndex = gender
        genderSegmentedControl.setTitle("Male", forSegmentAt: Gender.male.rawValue)
        genderSegmentedControl.setTitle("Female", forSegmentAt: Gender.female.rawValue)
        genderSegmentedControl.tintColor = Palette.textColor

        ageTextField.delegate = self
        ageTextField.clearButtonMode = .whileEditing
        ageTextField.placeholder = "Age"
        ageTextField.textAlignment = .center
        ageTextField.clearsOnBeginEditing = true
        ageTextField.keyboardType = .numberPad
        ageTextField.returnKeyType = .done
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
        
        profileImageView.backgroundColor = Palette.backgoundColor
        profileImageView.image = #imageLiteral(resourceName: "poo-icon")
        
        nicknameTextField.delegate = self
        nicknameTextField.clearButtonMode = .whileEditing
        nicknameTextField.placeholder = "Name"
        nicknameTextField.textAlignment = .center
        nicknameTextField.clearsOnBeginEditing = true
        nicknameTextField.keyboardType = .alphabet
        nicknameTextField.returnKeyType = .done
    
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
