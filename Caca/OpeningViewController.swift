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

        self.goBackButton.setTitle("", for: .normal)
        let buttonimage = #imageLiteral(resourceName: "goBack").withRenderingMode(.alwaysTemplate)
        self.goBackButton.setImage(buttonimage, for: .normal)
        self.goBackButton.tintColor = Palette.darkblue

        self.pageControl.currentPage = index

        switch index {

        case 0:

            self.forwardButton.setTitle("Next", for: .normal)
            self.goBackButton.isHidden = false
            self.boy.isHidden = false
            self.girl.isHidden = false
            self.toilet.isHidden = true
            self.cacaLogo.isHidden = true

        case 1:

            self.forwardButton.setTitle("Next", for: .normal)
            self.goBackButton.isHidden = true
            self.boy.isHidden = true
            self.girl.isHidden = true
            self.toilet.isHidden = false
            self.cacaLogo.isHidden = true

        case 2:

            self.forwardButton.setTitle("Done", for: .normal)
            self.goBackButton.isHidden = true
            self.boy.isHidden = true
            self.girl.isHidden = true
            self.toilet.isHidden = true
            self.cacaLogo.isHidden = false

        default: break

        }

    }

}
