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

        // MARK : Create user anonymously

        UserManager.shared.createAnonymousUser { (createError, storageError) in

            if let error = createError {

                let alertController = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert to make user know something wrong happened"),
                                                        message: error.localizedDescription,
                                                        preferredStyle: .alert)

                alertController.addAction(UIAlertAction(title: "OK",
                                                        style: .default,
                                                        handler: nil))

                self.present(alertController, animated: true, completion: nil)

            } else if let error = storageError {

                let alertController = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert to make user know something wrong happened"),
                                                        message: error.localizedDescription,
                                                        preferredStyle: .alert)

                alertController.addAction(UIAlertAction(title: "OK",
                                                        style: .default,
                                                        handler: nil))

                self.present(alertController, animated: true, completion: nil)

            }

        }

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

            let openingPageViewController = UIStoryboard(name: Constants.Storyboard.opening, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.openingPage) as? OpeningPageViewController

            let openingViewController = UIStoryboard(name: Constants.Storyboard.opening, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.opening) as? OpeningViewController

            openingViewController?.isFromStart = true

            appDelegate.window?.rootViewController = openingPageViewController

            UserDefaults.standard.set(NSLocalizedString("Hello", comment: "Greet user"), forKey: Constants.UserDefaultsKey.name)
            UserDefaults.standard.set(0, forKey: Constants.UserDefaultsKey.gender)
            UserDefaults.standard.set("", forKey: Constants.UserDefaultsKey.age)
            UserDefaults.standard.set(false, forKey: Constants.UserDefaultsKey.medicine)

        }

    }

    @IBAction func goToSignIn(_ sender: UIButton) {

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

            let signInViewController = UIStoryboard(name: Constants.Storyboard.landing, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.signIn) as? SignInViewController

            appDelegate.window?.rootViewController = signInViewController

        }
    }

    @IBAction func goTiSignUp(_ sender: UIButton) {

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

            let signUpViewController = UIStoryboard(name: Constants.Storyboard.landing, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.signUp) as? SignUpViewController

            signUpViewController?.isFromStart = true

            appDelegate.window?.rootViewController = signUpViewController

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
        self.appName.font = UIFont(name: Constants.UIFont.futuraBold, size: 60)

        self.startButton.backgroundColor = Palette.darkblue2
        self.startButton.setTitle(NSLocalizedString("Start Now", comment: "Start without logging in or signing up"), for: .normal)
        self.startButton.layer.cornerRadius = self.startButton.frame.height / 2
        self.startButton.tintColor = Palette.cream
        self.startButton.titleLabel?.font = UIFont(name: Constants.UIFont.futuraBold, size: 20)

        self.signInButton.backgroundColor = Palette.darkblue2
        self.signInButton.setTitle(NSLocalizedString("Log In", comment: ""), for: .normal)
        self.signInButton.layer.cornerRadius = self.signInButton.frame.height / 2
        self.signInButton.tintColor = Palette.cream
        self.signInButton.titleLabel?.font = UIFont(name: Constants.UIFont.futuraBold, size: 20)

        self.signUpButton.backgroundColor = Palette.darkblue2
        self.signUpButton.setTitle(NSLocalizedString("Sign Up", comment: ""), for: .normal)
        self.signUpButton.layer.cornerRadius = self.signUpButton.frame.height / 2
        self.signUpButton.tintColor = Palette.cream
        self.signUpButton.titleLabel?.font = UIFont(name: Constants.UIFont.futuraBold, size: 20)

    }

}
