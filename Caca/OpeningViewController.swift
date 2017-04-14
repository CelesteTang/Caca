//
//  OpeningViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/20.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class OpeningViewController: UIViewController {

    @IBOutlet weak var openingLabel: UILabel!

    @IBOutlet weak var openingImage: UIImageView!

    @IBOutlet weak var pageControl: UIPageControl!

    @IBOutlet weak var forwardButton: UIButton!

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

        self.view.backgroundColor = Palette.backgoundColor
        self.openingLabel.textColor = Palette.textColor
        self.forwardButton.tintColor = Palette.textColor

        self.openingLabel.text = heading
        self.openingImage.image = UIImage(named: imageFile)

        self.pageControl.currentPage = index

        switch index {
            
        case 0...1: self.forwardButton.setTitle("Next", for: .normal)
            
        case 2: self.forwardButton.setTitle("Done", for: .normal)
            
        default: break
            
        }
    }

}
