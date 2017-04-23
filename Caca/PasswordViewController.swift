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

    var isFromPassword = false

    var isFromPasswordChanging = false

    var isFromBeginning = false

    var isFirst = false

    var isSecond = false

    var numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "Clean", "0", "Delete"]

    var finalUserPassword = [String]()

    var userPassword = [String]()

    @IBOutlet weak var cancelButton: UIButton!

    @IBOutlet weak var passwordLabel: UILabel!

    @IBOutlet weak var password1: UIImageView!

    @IBOutlet weak var password2: UIImageView!

    @IBOutlet weak var password3: UIImageView!

    @IBOutlet weak var password4: UIImageView!

    @IBOutlet weak var numberCollectionView: UICollectionView!

    @IBAction func cancel(_ sender: UIButton) {

        if isFromPassword == true {

            UserDefaults.standard.set(false, forKey: "PasswordAuthentication")

            userPassword.removeAll()

            isFromPassword = false

            dismiss(animated: true, completion: nil)
            
//            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//                
//                let passwordStorybard = UIStoryboard(name: "Password", bundle: nil)
//                guard let passwordViewController = passwordStorybard.instantiateViewController(withIdentifier: "PasswordViewController") as? PasswordViewController else { return }
//                
//                passwordViewController.isFromPassword = true
//                passwordViewController.isFirst = true
//                passwordViewController.isSecond = false
//                
//                appDelegate.window?.rootViewController = passwordViewController
//            }


        } else if isFromPasswordChanging == true {

            userPassword.removeAll()

            isFromPasswordChanging = false

            dismiss(animated: true, completion: nil)

        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        touchIDAuthentication()

        numberCollectionView.dataSource = self
        numberCollectionView.delegate = self
        numberCollectionView.allowsSelection = true

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

        if isFirst == true {

            self.passwordLabel.text = "Please enter your password"

        } else if isSecond == true {

            self.passwordLabel.text = "Please enter your password again"

        }
        self.passwordLabel.textColor = Palette.darkblue
        self.passwordLabel.font = UIFont(name: "Futura-Bold", size: 20)

        self.cancelButton.setTitle("", for: .normal)
        let buttonImage = #imageLiteral(resourceName: "cancel").withRenderingMode(.alwaysTemplate)
        self.cancelButton.setImage(buttonImage, for: .normal)
        self.cancelButton.tintColor = Palette.darkblue

        if isFromPassword == true || isFromPasswordChanging == true {

            self.cancelButton.isHidden = false
            self.cancelButton.isEnabled = true

        } else if isFromBeginning == true {

            self.cancelButton.isHidden = true
            self.cancelButton.isEnabled = false

        }

        UserDefaults.standard.set(["1", "2", "3", "4"], forKey: "Password")

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
        cell.itemView.numberLabel.textColor = Palette.darkblue
        cell.itemView.numberLabel.font = UIFont(name: "Futura-Bold", size: 20)

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

        switch userPassword.count {
        case 1:
            password1.image = #imageLiteral(resourceName: "caca-small")
        case 2:
            password1.image = #imageLiteral(resourceName: "caca-small")
            password2.image = #imageLiteral(resourceName: "caca-small")
        case 3:
            password1.image = #imageLiteral(resourceName: "caca-small")
            password2.image = #imageLiteral(resourceName: "caca-small")
            password3.image = #imageLiteral(resourceName: "caca-small")
        case 4:
            password1.image = #imageLiteral(resourceName: "caca-small")
            password2.image = #imageLiteral(resourceName: "caca-small")
            password3.image = #imageLiteral(resourceName: "caca-small")
            password4.image = #imageLiteral(resourceName: "caca-small")
        default: break
        }
        
        if userPassword.count == 4 {

            numberCollectionView.allowsSelection = false

            if UserDefaults.standard.value(forKey: "Password") == nil {

                if isFirst == true {

                    finalUserPassword = userPassword

                    dismiss(animated: true, completion: nil)

                } else if isSecond == true {

                    if userPassword == finalUserPassword {

                        UserDefaults.standard.set(userPassword, forKey: "Password")

                        isFromPassword = false
                        isSecond = false

                        dismiss(animated: true, completion: nil)

                    } else {

                        let alertController = UIAlertController(
                            title: "Warning",
                            message: "The password is different. Try again.",
                            preferredStyle: .alert)

                        let okAction = UIAlertAction(
                            title: "OK",
                            style: .default,
                            handler: nil)

                        userPassword.removeAll()

                        alertController.addAction(okAction)

                        self.present(
                            alertController,
                            animated: true,
                            completion: nil)

                    }
                }

            } else if let storedPassword = UserDefaults.standard.value(forKey: "Password") as? [String], userPassword == storedPassword {

                if isFromBeginning == true {

                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                        appDelegate.window?.rootViewController = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? TabBarController

                    }

                }

            } else {

                let alertController = UIAlertController(
                    title: "Warning",
                    message: "The password is incorrect. Try again.",
                    preferredStyle: .alert)

                let okAction = UIAlertAction(
                    title: "OK",
                    style: .default,
                    handler: nil)

                userPassword.removeAll()

                alertController.addAction(okAction)

                self.present(
                    alertController,
                    animated: true,
                    completion: nil)
            }

        }

        print(userPassword)
    }

}
