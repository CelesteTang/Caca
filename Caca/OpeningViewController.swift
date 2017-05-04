//
//  OpeningViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/20.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class OpeningViewController: UIViewController {

    @IBOutlet weak var boy: UIImageView!

    @IBOutlet weak var girl: UIImageView!

    @IBOutlet weak var toilet: UIImageView!

    @IBOutlet weak var cacaLogo: UIImageView!

    @IBOutlet weak var openingLabel: UILabel!

    @IBOutlet weak var openingImage: UIImageView!

    @IBOutlet weak var pageControl: UIPageControl!

    @IBOutlet weak var forwardButton: UIButton!

    @IBOutlet weak var startButton: UIButton!

    @IBAction func goBack(_ sender: UIButton) {

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

            let startViewController = UIStoryboard(name: Constants.Storyboard.landing, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.start) as? StartViewController

            appDelegate.window?.rootViewController = startViewController

        }

    }

    @IBAction func start(_ sender: UIButton) {

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

            UserDefaults.standard.set(true, forKey: Constants.UserDefaultsKey.isViewedWalkThrough)

            let tabBarController = UIStoryboard(name: Constants.Storyboard.tabBar, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.tabBar) as? TabBarController

            appDelegate.window?.rootViewController = tabBarController

        }

    }

    @IBAction func openingButton(_ sender: UIButton) {

        switch index {

        case 0...1:

            guard let pageViewController = parent as? OpeningPageViewController else { return }
            pageViewController.forward(index: index)

        default: break

        }
    }

    var index = 0
    var heading = ""
    var imageFile = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()

    }

    // MARK: Set Up

    private func setUp() {

        self.view.backgroundColor = Palette.lightblue2

        self.forwardButton.tintColor = Palette.darkblue

        self.openingLabel.textColor = Palette.darkblue
        self.openingLabel.text = heading
        self.openingLabel.font = UIFont(name: Constants.UIFont.futuraBold, size: 30)

        self.openingImage.image = UIImage(named: imageFile)

        self.startButton.setTitle(NSLocalizedString("Start", comment: ""), for: .normal)
        self.startButton.tintColor = Palette.cream
        self.startButton.backgroundColor = Palette.darkblue2
        self.startButton.layer.cornerRadius = self.startButton.frame.height / 2
        self.startButton.titleLabel?.font = UIFont(name: Constants.UIFont.futuraBold, size: 20)

        self.pageControl.currentPage = index

        switch index {

        case 0:

            self.forwardButton.setTitle(NSLocalizedString("Next", comment: ""), for: .normal)
            self.forwardButton.titleLabel?.font = UIFont(name: Constants.UIFont.futuraBold, size: 20)
            self.boy.isHidden = false
            self.girl.isHidden = false
            self.toilet.isHidden = true
            self.cacaLogo.isHidden = true
            self.startButton.isHidden = true
            self.startButton.isEnabled = false

        case 1:

            self.forwardButton.setTitle(NSLocalizedString("Next", comment: ""), for: .normal)
            self.forwardButton.titleLabel?.font = UIFont(name: Constants.UIFont.futuraBold, size: 20)
            self.boy.isHidden = true
            self.girl.isHidden = true
            self.toilet.isHidden = false
            self.cacaLogo.isHidden = true
            self.startButton.isHidden = true
            self.startButton.isEnabled = false

        case 2:

            self.forwardButton.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
            self.forwardButton.titleLabel?.font = UIFont(name: Constants.UIFont.futuraBold, size: 20)
            self.boy.isHidden = true
            self.girl.isHidden = true
            self.toilet.isHidden = true
            self.cacaLogo.isHidden = false
            self.startButton.isHidden = false
            self.startButton.isEnabled = true
            self.forwardButton.isHidden = true
            self.forwardButton.isEnabled = false

        default: break

        }
    }
}
