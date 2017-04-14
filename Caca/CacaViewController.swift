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

    var cacas = [Caca]()

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

        var dayToNow = Int()
        
        navigationItem.title = Time().dateString()
        notificationLabel.textColor = Palette.textColor
        startButton.backgroundColor = Palette.textColor
        startButton.tintColor = Palette.backgoundColor
        startButton.layer.cornerRadius = 15

        if let name = UserDefaults.standard.value(forKey: "Nickname") as? String {

            notificationLabel.text = "\(name), you don't defecate for \(dayToNow) days"

        } else {

            notificationLabel.text = "You don't defecate for \(dayToNow) days"

        }
        notificationLabel.numberOfLines = 0
        startButton.setTitle("Start", for: UIControlState.normal)
        view.backgroundColor = Palette.backgoundColor

        if let gender = UserDefaults.standard.value(forKey: "Gender") as? Int {

            if gender == Gender.male.rawValue {

                mainImageView.backgroundColor = Palette.backgoundColor
                mainImageView.image = #imageLiteral(resourceName: "poo-icon")

            } else {

                mainImageView.backgroundColor = Palette.backgoundColor

            }

        }

        CacaProvider.shared.getCaca { (cacas, _) in

            if let cacas = cacas {

                self.cacas = cacas
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 8)
                guard let lastCacaDate = cacas.last?.date else { return }
                guard let date = dateFormatter.date(from: lastCacaDate) else { return }

                dayToNow = Date().daysBetweenDate(toDate: date)
                
                print(dayToNow)
            }

        }

    }

}

extension CacaViewController {

    // swiftlint:disable force_cast
    class func create() -> CacaViewController {

        return UIStoryboard(name: "Caca", bundle: nil).instantiateViewController(withIdentifier: "CacaViewController") as! CacaViewController

    }
    // swiftlint:enable force_cast

}

extension Date {
    
    func daysBetweenDate(toDate: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: toDate)
        return components.day ?? 0
    }
    
}
