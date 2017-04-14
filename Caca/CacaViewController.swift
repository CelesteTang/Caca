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

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController = UIStoryboard(name: "Timing", bundle: nil).instantiateViewController(withIdentifier: "TimingViewController") as? TimingViewController
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()

        guard let userName = UserDefaults.standard.value(forKey: "Name") as? String else { return }
        notificationLabel.text = "\(userName), how's today?"

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

                if cacas.last?.date == nil {

                    self.notificationLabel.text = "\(userName), start caca now!"

                } else {

                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    dateFormatter.timeZone = TimeZone(secondsFromGMT: 8)
                    var dayToNow = Int()
                    
                    if let lastCacaDate = cacas.last?.date,
                       let date = dateFormatter.date(from: lastCacaDate) {

                        dayToNow = date.daysBetweenDate(toDate: Date())

                        switch dayToNow {

                        case 0:
                            self.notificationLabel.text = "\(userName), you caca today."
                            
                        case 1:
                            self.notificationLabel.text = "\(userName), you don't caca today."
                            
                        case 2...6:
                            self.notificationLabel.text = "\(userName), you don't caca for \(dayToNow) days."
                            
                        case 7:
                            self.notificationLabel.text = "\(userName), you don't caca for a week."
                            
                        default:
                            self.notificationLabel.text = "\(userName), you don't caca for a long time."

                        }

                    }

                }

            }

        }

    }

    // MARK: Set Up

    private func setUp() {

        self.navigationItem.title = Time().dateString()
        
        self.view.backgroundColor = Palette.backgoundColor

        self.notificationLabel.textColor = Palette.textColor
        self.notificationLabel.numberOfLines = 0

        self.startButton.backgroundColor = Palette.textColor
        self.startButton.tintColor = Palette.backgoundColor
        self.startButton.layer.cornerRadius = 15
        self.startButton.setTitle("Start", for: UIControlState.normal)

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
