//
//  OpeningViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/20.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class OpeningViewController: UIViewController {

    @IBOutlet weak var goBackButton: UIButton!

    @IBOutlet weak var openingLabel: UILabel!

    @IBOutlet weak var openingImage: UIImageView!

    @IBOutlet weak var pageControl: UIPageControl!

    @IBOutlet weak var forwardButton: UIButton!

    @IBAction func goBack(_ sender: UIButton) {

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController = UIStoryboard(name: "Landing", bundle: nil).instantiateViewController(withIdentifier: "StartViewController") as? StartViewController
        }

    }

    @IBAction func openingButton(_ sender: UIButton) {

        switch index {

        case 0...1:
            guard let pageViewController = parent as? OpeningPageViewController else { return }
            pageViewController.forward(index: index)

        case 2:
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.window?.rootViewController = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? TabBarController
            }

        default: break

        }
    }

    var index = 0
    var heading = ""
    var imageFile = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Palette.lightblue2
        self.openingLabel.textColor = Palette.darkblue
        self.forwardButton.tintColor = Palette.darkblue

        self.openingLabel.text = heading
        self.openingImage.image = UIImage(named: imageFile)

        self.goBackButton.setImage(#imageLiteral(resourceName: "GoBack"), for: .normal)
        self.goBackButton.setTitle("", for: .normal)

        self.pageControl.currentPage = index

        switch index {

        case 0:

            self.forwardButton.setTitle("Next", for: .normal)
            self.goBackButton.isHidden = false

        case 1:

            self.forwardButton.setTitle("Next", for: .normal)
            self.goBackButton.isHidden = true

        case 2:

            self.forwardButton.setTitle("Done", for: .normal)
            self.goBackButton.isHidden = true

        default: break

        }

    }

}
