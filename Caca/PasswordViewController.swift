//
//  PasswordViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/6.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {

    @IBOutlet weak var passwordLabel: UILabel!

    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Palette.backgoundColor
        passwordLabel.text = "Please enter your password"

        passwordField.delegate = self
        passwordField.clearButtonMode = .never
        passwordField.placeholder = "Password"
        passwordField.clearsOnBeginEditing = true
        passwordField.isSecureTextEntry = true
        passwordField.returnKeyType = .done

        UserDefaults.standard.set("1234", forKey: "Password")

    }

//    func savePassword() {
//        
//        UserDefaults.standard.set(passwordField.text, forKey: "Password")
//    
//    }
    
}

extension PasswordViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)

        if passwordField.text == UserDefaults.standard.value(forKey: "Password") as? String {
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.window?.rootViewController = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? TabBarController
                
            }
        }
        
        return true
    }
}
