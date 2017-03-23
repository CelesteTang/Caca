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

//        let timingStorybard = UIStoryboard(name: "Timing", bundle: nil)
//        let timingViewController = timingStorybard.instantiateViewController(withIdentifier: "TimingViewController")
//
//        present(timingViewController, animated: true)

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController = UIStoryboard(name: "Timing", bundle: nil).instantiateViewController(withIdentifier: "TimingViewController") as? TimingViewController
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = dateString()
        view.backgroundColor = UIColor.brown

    }

    func dateString() -> String {

        let date = Date()
        let calendar = Calendar.current

        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)

        return String(format: "%04i/%02i/%02i", year, month, day)
    }
}

extension CacaViewController {

    // swiftlint:disable force_cast
    class func create() -> CacaViewController {

        return UIStoryboard(name: "Caca", bundle: nil).instantiateViewController(withIdentifier: "CacaViewController") as! CacaViewController

    }
    // swiftlint:enable force_cast

}
