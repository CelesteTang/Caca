//
//  LandingViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/23.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!

    @IBOutlet weak var appNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Palette.backgoundColor
        logoImageView.image = #imageLiteral(resourceName: "poo-icon")
        appNameLabel.text = "Caca"
        appNameLabel.textColor = Palette.textColor
    }

}
