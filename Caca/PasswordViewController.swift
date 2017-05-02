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

    var numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", NSLocalizedString("Clean", comment: "Delete all"), "0", NSLocalizedString("Delete", comment: "Delete one")]

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

            UserDefaults.standard.set(false, forKey: Constants.UserDefaultsKey.passwordAuthentication)

            userPassword.removeAll()

            isFromPassword = false

            dismiss(animated: true, completion: nil)

            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

                let tabBarController = UIStoryboard(name: Constants.Storyboard.tabBar, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.tabBar) as? TabBarController

                tabBarController?.selectedIndex = TabBarItemType.setting.rawValue

                appDelegate.window?.rootViewController = tabBarController

            }

        } else if isFromPasswordChanging == true {

            userPassword.removeAll()

            isFromPasswordChanging = false

            dismiss(animated: true, completion: nil)

        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()

        if isFromBeginning == true {

            touchIDAuthentication()

        }

        numberCollectionView.dataSource = self
        numberCollectionView.delegate = self
        numberCollectionView.allowsSelection = true

        guard let layout = numberCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.itemSize = CGSize(width: numberCollectionView.frame.width / 3, height: numberCollectionView.frame.height / 4)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)

        numberCollectionView.register(NumberCollectionViewCell.self, forCellWithReuseIdentifier: "NumberCollectionViewCell")

    }

    // MARK: Set Up

    private func setUp() {

        self.view.backgroundColor = Palette.lightblue2
        self.numberCollectionView.backgroundColor = Palette.lightblue

        self.passwordLabel.text = NSLocalizedString("Please enter your password", comment: "")
        self.passwordLabel.textColor = Palette.darkblue
        self.passwordLabel.font = UIFont(name: Constants.UIFont.futuraBold, size: 20)

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

        self.password1.image = #imageLiteral(resourceName: "shadow")
        self.password2.image = #imageLiteral(resourceName: "shadow")
        self.password3.image = #imageLiteral(resourceName: "shadow")
        self.password4.image = #imageLiteral(resourceName: "shadow")

    }

    func touchIDAuthentication() {

        if UserDefaults.standard.bool(forKey: Constants.UserDefaultsKey.touchIDAuthentication) == true && UserDefaults.standard.value(forKey: Constants.UserDefaultsKey.password) as? [String] != nil {

            let context = LAContext()

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {

                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: NSLocalizedString("Use TouchID to enter Caca", comment: ""), reply: { (success, _) in

                    if success {

                        DispatchQueue.main.async {

                            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

                                let tabBarController = UIStoryboard(name: Constants.Storyboard.tabBar, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.tabBar) as? TabBarController

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
        cell.itemView.numberLabel.font = UIFont(name: Constants.UIFont.futuraBold, size: 20)

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

        DispatchQueue.main.async {

            switch self.userPassword.count {
            case 0:
                self.password1.image = #imageLiteral(resourceName: "shadow")
                self.password2.image = #imageLiteral(resourceName: "shadow")
                self.password3.image = #imageLiteral(resourceName: "shadow")
                self.password4.image = #imageLiteral(resourceName: "shadow")
            case 1:
                self.password1.image = #imageLiteral(resourceName: "caca-small")
                self.password2.image = #imageLiteral(resourceName: "shadow")
                self.password3.image = #imageLiteral(resourceName: "shadow")
                self.password4.image = #imageLiteral(resourceName: "shadow")
            case 2:
                self.password1.image = #imageLiteral(resourceName: "caca-small")
                self.password2.image = #imageLiteral(resourceName: "caca-small")
                self.password3.image = #imageLiteral(resourceName: "shadow")
                self.password4.image = #imageLiteral(resourceName: "shadow")
            case 3:
                self.password1.image = #imageLiteral(resourceName: "caca-small")
                self.password2.image = #imageLiteral(resourceName: "caca-small")
                self.password3.image = #imageLiteral(resourceName: "caca-small")
                self.password4.image = #imageLiteral(resourceName: "shadow")

            case 4:
                self.password1.image = #imageLiteral(resourceName: "caca-small")
                self.password2.image = #imageLiteral(resourceName: "caca-small")
                self.password3.image = #imageLiteral(resourceName: "caca-small")
                self.password4.image = #imageLiteral(resourceName: "caca-small")

            default: break

            }

        }

        if userPassword.count == 4 {

            numberCollectionView.allowsSelection = false

            if UserDefaults.standard.value(forKey: Constants.UserDefaultsKey.password) == nil {

                UserDefaults.standard.set(userPassword, forKey: Constants.UserDefaultsKey.password)

                dismiss(animated: true, completion: nil)

            } else if let storedPassword = UserDefaults.standard.value(forKey: Constants.UserDefaultsKey.password) as? [String], userPassword == storedPassword {

                if isFromBeginning == true {

                    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

                        let tabBarController = UIStoryboard(name: Constants.Storyboard.tabBar, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.tabBar) as? TabBarController

                        appDelegate.window?.rootViewController = tabBarController

                        isFromBeginning = false

                    }

                } else if isFromPasswordChanging == true {

                    UserDefaults.standard.set(userPassword, forKey: Constants.UserDefaultsKey.password)

                    isFromPasswordChanging = false

                    dismiss(animated: true, completion: nil)

                }

            } else {

                if isFromBeginning == true {

                    let alertController = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert to make user know something wrong happened"),
                                                            message: NSLocalizedString("The password is incorrect. Try again.", comment: ""),
                                                            preferredStyle: UIAlertControllerStyle.alert)

                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in

                        self.userPassword.removeAll()

                        self.password1.image = #imageLiteral(resourceName: "shadow")
                        self.password2.image = #imageLiteral(resourceName: "shadow")
                        self.password3.image = #imageLiteral(resourceName: "shadow")
                        self.password4.image = #imageLiteral(resourceName: "shadow")

                        self.numberCollectionView.allowsSelection = true

                    })

                    alertController.addAction(okAction)

                    self.present(alertController, animated: true, completion: nil)

                } else if isFromPasswordChanging == true {

                    UserDefaults.standard.set(userPassword, forKey: Constants.UserDefaultsKey.password)

                    isFromPasswordChanging = false

                    dismiss(animated: true, completion: nil)

                }
            }
        }
    }
}
