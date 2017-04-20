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

    @IBOutlet weak var passwordLabel: UILabel!

    @IBOutlet weak var passwordField: UITextField!

    @IBOutlet weak var numberCollectionView: UICollectionView!

    var numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "Cancel", "0", "Delete"]

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        touchIDAuthentication()

        numberCollectionView.dataSource = self
        numberCollectionView.delegate = self
        guard let layout = numberCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        layout.itemSize = CGSize(width: numberCollectionView.frame.width / 3, height: numberCollectionView.frame.height / 4)
//        let columnGap = (numberCollectionView.bounds.width - layout.itemSize.width * 3) / 4
//        let rowGap = (numberCollectionView.bounds.height - layout.itemSize.height * 4) / 5
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
//        layout.sectionInset = UIEdgeInsets(top: rowGap, left: columnGap, bottom: rowGap, right: columnGap)

        numberCollectionView.register(NumberCollectionViewCell.self, forCellWithReuseIdentifier: "NumberCollectionViewCell")

    }

    // MARK: Set Up

    private func setUp() {

        self.view.backgroundColor = Palette.backgoundColor
        self.passwordLabel.text = "Please enter your password"

        self.passwordField.delegate = self
        self.passwordField.clearButtonMode = .never
        self.passwordField.placeholder = "Password"
        self.passwordField.textAlignment = .center
        self.passwordField.clearsOnBeginEditing = true
        self.passwordField.isSecureTextEntry = true
        self.passwordField.returnKeyType = .done

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

        return cell
    }

}

extension PasswordViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)

        if UserDefaults.standard.string(forKey: "Password") == nil {

            UserDefaults.standard.set(passwordField.text, forKey: "Password")

            dismiss(animated: true, completion: nil)

        } else {

            if passwordField.text == UserDefaults.standard.value(forKey: "Password") as? String {

                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                    appDelegate.window?.rootViewController = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? TabBarController

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

                alertController.addAction(okAction)

                self.present(
                    alertController,
                    animated: true,
                    completion: nil)
            }
        }

        return true
    }
}
