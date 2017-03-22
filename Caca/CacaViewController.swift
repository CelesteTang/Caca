//
//  CacaViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/20.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class CacaViewController: UIViewController {
    @IBAction func switchToTiming(_ sender: UIButton) {

        let signUpStorybard = UIStoryboard(name: "Timing", bundle: nil)
        let signUpViewController = signUpStorybard.instantiateViewController(withIdentifier: "TimingViewController")

        present(signUpViewController, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "2017/03/21"
        view.backgroundColor = UIColor.brown

    }

}

extension CacaViewController {

    // swiftlint:disable force_cast
    class func create() -> CacaViewController {

        return UIStoryboard(name: "Caca", bundle: nil).instantiateViewController(withIdentifier: "CacaViewController") as! CacaViewController

    }
    // swiftlint:enable force_cast

}
