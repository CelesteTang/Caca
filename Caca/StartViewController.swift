//
//  StartViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/15.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!

    @IBOutlet weak var appName: UILabel!

    @IBOutlet weak var startButton: UIButton!

    @IBOutlet weak var signInButton: UIButton!

    @IBOutlet weak var signUpButton: UIButton!

    @IBAction func startDirectly(_ sender: UIButton) {

        let alertController = UIAlertController(title: "Just a reminder",
                                                message: "You could sign up later if you want to backup your info",
                                                preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "Go back", style: .cancel) { _ in

            alertController.dismiss(animated: true, completion: nil)

        }
        alertController.addAction(cancelAction)

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in

            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.window?.rootViewController = UIStoryboard(name: "Opening", bundle: nil).instantiateViewController(withIdentifier: "OpeningPageViewController") as? OpeningPageViewController
            }
        }
        alertController.addAction(okAction)

        self.present(alertController, animated: true, completion: nil)

    }

    @IBAction func goToSignIn(_ sender: UIButton) {

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController = UIStoryboard(name: "Landing", bundle: nil).instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController
        }
    }

    @IBAction func goTiSignUp(_ sender: UIButton) {

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController = UIStoryboard(name: "Landing", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }

    // MARK: Set Up

    private func setUp() {

        self.view.backgroundColor = Palette.backgoundColor
        self.logoImageView.image = #imageLiteral(resourceName: "poo-icon")
        self.logoImageView.backgroundColor = Palette.backgoundColor

        self.appName.text = "Caca"
        self.appName.textColor = Palette.textColor
        self.appName.font = UIFont(name: "Courier-Bold", size: 60)

        self.startButton.backgroundColor = Palette.textColor
        self.startButton.setTitle("Start Now", for: .normal)
        self.startButton.layer.cornerRadius = 15

        self.signInButton.backgroundColor = Palette.textColor
        self.signInButton.setTitle("Sign In", for: .normal)
        self.signInButton.layer.cornerRadius = 15

        self.signUpButton.backgroundColor = Palette.textColor
        self.signUpButton.setTitle("Sign Up", for: .normal)
        self.signUpButton.layer.cornerRadius = 15
    }

}
