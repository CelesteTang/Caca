//
//  CacaViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/20.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class CacaViewController: UIViewController {

    @IBOutlet weak var mainImageView: UIImageView!

    @IBOutlet weak var notificationLabel: UILabel!

    @IBOutlet weak var startButton: UIButton!

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
        notificationLabel.textColor = Palette.textColor
        startButton.backgroundColor = Palette.textColor
        startButton.tintColor = Palette.backgoundColor
        startButton.layer.cornerRadius = 15

        notificationLabel.text = "You don't defecate for 3 days"
        notificationLabel.numberOfLines = 0
        startButton.setTitle("Start", for: UIControlState.normal)
        view.backgroundColor = Palette.backgoundColor

        if let gender = UserDefaults.standard.value(forKey: "Gender") as? Int  {

            if gender == Gender.male.rawValue {
                
                mainImageView.backgroundColor = Palette.backgoundColor
                mainImageView.image = #imageLiteral(resourceName: "poo-icon")
                
            } else {
                
                mainImageView.backgroundColor = Palette.backgoundColor
                
            }

        }

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
