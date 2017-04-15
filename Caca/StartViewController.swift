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
    
    @IBAction func startDirectly(_ sender: UIButton) {
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController = UIStoryboard(name: "Opening", bundle: nil).instantiateViewController(withIdentifier: "OpeningPageViewController") as? OpeningPageViewController
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
        self.startButton.setTitle("Start", for: .normal)
    }

}
