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

            } else if let error = storageError {

                let alertController = UIAlertController(title: "Warning",
                                                        message: error.localizedDescription,
                                                        preferredStyle: .alert)

                alertController.addAction(UIAlertAction(title: "OK",
                                                        style: .default,
                                                        handler: nil))

                self.present(alertController, animated: true, completion: nil)

            }

        }

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

            let openingPageViewController = UIStoryboard(name: "Opening", bundle: nil).instantiateViewController(withIdentifier: "OpeningPageViewController") as? OpeningPageViewController

            let openingViewController = UIStoryboard(name: "Opening", bundle: nil).instantiateViewController(withIdentifier: "OpeningViewController") as? OpeningViewController

            openingViewController?.isFromStart = true

            appDelegate.window?.rootViewController = openingPageViewController

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
        self.logoImageView.image = #imageLiteral(resourceName: "caca-big")
        self.logoImageView.backgroundColor = Palette.lightblue2

        self.appName.text = "Caca"
        self.appName.textColor = Palette.darkblue2
        self.appName.font = UIFont(name: "Futura-Bold", size: 60)

        self.startButton.backgroundColor = Palette.darkblue2
        self.startButton.setTitle("Start Now", for: .normal)
        self.startButton.layer.cornerRadius = self.startButton.frame.height / 2
        self.startButton.tintColor = Palette.cream
        self.startButton.titleLabel?.font = UIFont(name: "Futura-Bold", size: 20)

        self.signInButton.backgroundColor = Palette.darkblue2
        self.signInButton.setTitle("Log In", for: .normal)
        self.signInButton.layer.cornerRadius = self.signInButton.frame.height / 2
        self.signInButton.tintColor = Palette.cream
        self.signInButton.titleLabel?.font = UIFont(name: "Futura-Bold", size: 20)

        self.signUpButton.backgroundColor = Palette.darkblue2
        self.signUpButton.setTitle("Sign Up", for: .normal)
        self.signUpButton.layer.cornerRadius = self.signUpButton.frame.height / 2
        self.signUpButton.tintColor = Palette.cream
        self.signUpButton.titleLabel?.font = UIFont(name: "Futura-Bold", size: 20)

    }

}
