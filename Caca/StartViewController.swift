//
//  StartViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/15.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit
import Firebase

class StartViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!

    @IBOutlet weak var appName: UILabel!

    @IBOutlet weak var startButton: UIButton!

    @IBOutlet weak var signInButton: UIButton!

    @IBOutlet weak var signUpButton: UIButton!

    @IBAction func startDirectly(_ sender: UIButton) {

        UserManager.shared.createAnonymousUser { (createError, storageError) in

            if let error = createError {

                let alertController = UIAlertController(title: "Warning",
                                                        message: error.localizedDescription,
                                                        preferredStyle: .alert)

                alertController.addAction(UIAlertAction(title: "OK",
                                                        style: .default,
                                                        handler: nil))

                self.present(alertController, animated: true, completion: nil)

            }

            if let error = storageError {

                let alertController = UIAlertController(title: "Warning",
                                                        message: error.localizedDescription,
                                                        preferredStyle: .alert)

                alertController.addAction(UIAlertAction(title: "OK",
                                                        style: .default,
                                                        handler: nil))

                self.present(alertController, animated: true, completion: nil)

            }

            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.window?.rootViewController = UIStoryboard(name: "Opening", bundle: nil).instantiateViewController(withIdentifier: "OpeningPageViewController") as? OpeningPageViewController
            }
        }
    }

    @IBAction func goToSignIn(_ sender: UIButton) {

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController = UIStoryboard(name: "Landing", bundle: nil).instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController
        }
    }

    @IBAction func goTiSignUp(_ sender: UIButton) {

        let signUpStoryboard = UIStoryboard(name: "Landing", bundle: nil)

        guard let signUpViewController = signUpStoryboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else { return }

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

            appDelegate.window?.rootViewController = signUpViewController

            signUpViewController.isFromStart = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }

    // MARK: Set Up

    private func setUp() {

        self.view.backgroundColor = Palette.lightblue2
        self.logoImageView.image = #imageLiteral(resourceName: "caca-icon")
        self.logoImageView.backgroundColor = Palette.lightblue2

        self.appName.text = "Caca"
        self.appName.textColor = Palette.darkblue
        self.appName.font = UIFont(name: "Courier-Bold", size: 60)

        self.startButton.backgroundColor = Palette.darkblue
        self.startButton.setTitle("Start Now", for: .normal)
        self.startButton.layer.cornerRadius = 15

        self.signInButton.backgroundColor = Palette.darkblue
        self.signInButton.setTitle("Sign In", for: .normal)
        self.signInButton.layer.cornerRadius = 15

        self.signUpButton.backgroundColor = Palette.darkblue
        self.signUpButton.setTitle("Sign Up", for: .normal)
        self.signUpButton.layer.cornerRadius = 15
    }

}
