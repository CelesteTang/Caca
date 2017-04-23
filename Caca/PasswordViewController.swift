//
//  PasswordViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/6.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit
import LocalAuthentication

class PasswordViewController: UIViewController {

    var isFromPrivacy = false

    var isFromBeginning = false

    var userPassword = [String]()

    @IBOutlet weak var cancelButton: UIButton!

    @IBOutlet weak var passwordLabel: UILabel!

    @IBOutlet weak var password1: UIImageView!
    
    @IBOutlet weak var password2: UIImageView!
    
    @IBOutlet weak var password3: UIImageView!
    
    @IBOutlet weak var password4: UIImageView!
    
    @IBOutlet weak var numberCollectionView: UICollectionView!

    @IBAction func cancel(_ sender: UIButton) {

//        if isFromPrivacy == true {
//
//            dismiss(animated: true, completion: nil)
//
//            isFromPrivacy = false
//
//        }

        dismiss(animated: true, completion: nil)

    }

    var numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "Clean", "0", "Delete"]

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        touchIDAuthentication()

        numberCollectionView.dataSource = self
        numberCollectionView.delegate = self

        guard let layout = numberCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.itemSize = CGSize(width: numberCollectionView.frame.width / 3, height: numberCollectionView.frame.height / 4)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

        numberCollectionView.register(NumberCollectionViewCell.self, forCellWithReuseIdentifier: "NumberCollectionViewCell")

    }

    // MARK: Set Up

    private func setUp() {

        self.view.backgroundColor = Palette.lightblue2
        self.passwordLabel.text = "Please enter your password"
//
//        self.passwordField.delegate = self
//        self.passwordField.clearButtonMode = .never
//        self.passwordField.placeholder = "Password"
//        self.passwordField.textAlignment = .center
//        self.passwordField.clearsOnBeginEditing = true
//        self.passwordField.isSecureTextEntry = true
//        self.passwordField.returnKeyType = .done

        self.cancelButton.setTitle("", for: .normal)
        let buttonImage = #imageLiteral(resourceName: "cancel").withRenderingMode(.alwaysTemplate)
        self.cancelButton.setImage(buttonImage, for: .normal)
        self.cancelButton.tintColor = Palette.darkblue

//        self.password1.isHidden = true
//        self.password2.isHidden = true
//        self.password3.isHidden = true
//        self.password4.isHidden = true

        if isFromPrivacy == true {

            self.cancelButton.isHidden = false
            self.cancelButton.isEnabled = true

        } else if isFromBeginning == true {

            self.cancelButton.isHidden = true
            self.cancelButton.isEnabled = false

        }

    }

    func touchIDAuthentication() {

        if UserDefaults.standard.bool(forKey: "TouchIDAuthentication") == true && UserDefaults.standard.string(forKey: "Password") != nil {

            let context = LAContext()

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {

                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Use TouchID to enter Caca", reply: { (success, _) in

                    if success {
                        DispatchQueue.main.async {

                            if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? TabBarController {

                                appDelegate.window?.rootViewController = tabBarController

                            }
                        }
                    }
                })
            }
        }
    }
}

extension PasswordViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return numbers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // swiftlint:disable force_cast
        let cell = numberCollectionView.dequeueReusableCell(withReuseIdentifier: "NumberCollectionViewCell", for: indexPath) as! NumberCollectionViewCell
        // swiftlint:enable force_cast

        cell.itemView.numberLabel.text = numbers[indexPath.item]
        
//        let backgroundView = UIView()
//        backgroundView.backgroundColor = Palette.darkblue
//        cell.selectedBackgroundView = backgroundView

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.item {

        case 0...8, 10:

            userPassword.append(numbers[indexPath.item])
            
        case 9:

            userPassword.removeAll()

        case 11:

            if userPassword.count > 0 {
                
                userPassword.removeLast()
                
            }

        default: break

        }
        
        print(userPassword)
    }

}

//extension PasswordViewController: UITextFieldDelegate {
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//
//        if UserDefaults.standard.string(forKey: "Password") == nil {
//
//            UserDefaults.standard.set(passwordField.text, forKey: "Password")
//
//            dismiss(animated: true, completion: nil)
//
//        } else {
//
//            if passwordField.text == UserDefaults.standard.value(forKey: "Password") as? String {
//
//                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//                    appDelegate.window?.rootViewController = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? TabBarController
//
//                }
//
//            } else {
//
//                let alertController = UIAlertController(
//                    title: "Warning",
//                    message: "The password is incorrect. Try again.",
//                    preferredStyle: .alert)
//
//                let okAction = UIAlertAction(
//                    title: "OK",
//                    style: .default,
//                    handler: nil)
//
//                alertController.addAction(okAction)
//
//                self.present(
//                    alertController,
//                    animated: true,
//                    completion: nil)
//            }
//        }
//
//        return true
//    }
//}
