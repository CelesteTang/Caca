//
//  CacaViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/20.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit
import Crashlytics
import Firebase

class CacaViewController: UIViewController {

    @IBOutlet weak var mainImageView: UIImageView!

    @IBOutlet weak var magnifierView: UIView!

    @IBOutlet weak var gutImageView: UIImageView!

    @IBOutlet weak var cacaImageView: UIImageView!

    @IBOutlet weak var magnifierButton: UIButton!

    @IBOutlet weak var notificationLabel: UILabel!

    @IBOutlet weak var startButton: UIButton!

    @IBAction func switchToTiming(_ sender: UIButton) {

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

            let timingViewController = UIStoryboard(name: "Timing", bundle: nil).instantiateViewController(withIdentifier: "TimingViewController") as? TimingViewController

            FIRAnalytics.logEvent(withName: "GoToTiming", parameters: nil)

            appDelegate.window?.rootViewController = timingViewController

        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()

        detectFrequency()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.magnifierView.layer.cornerRadius = self.magnifierView.frame.width / 2
        self.magnifierView.layer.masksToBounds = true

    }

    // MARK: Set Up

    private func setUp() {

        self.navigationItem.title = Time.dateString()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Palette.darkblue, NSFontAttributeName: UIFont(name: "Futura-Bold", size: 20) ?? ""]

        self.view.backgroundColor = Palette.lightblue2

        self.mainImageView.backgroundColor = Palette.lightblue2
        self.mainImageView.image = #imageLiteral(resourceName: "boy")
        if let gender = UserDefaults.standard.value(forKey: "Gender") as? Int {

            if gender == Gender.male.rawValue {

                mainImageView.image = #imageLiteral(resourceName: "boy")

            } else if gender == Gender.female.rawValue {

                mainImageView.image = #imageLiteral(resourceName: "girl")

            }
        }

        self.magnifierView.backgroundColor = Palette.lightWhite
        self.magnifierView.layer.borderWidth = 5
        self.magnifierView.layer.borderColor = Palette.orange.cgColor
        self.magnifierView.isHidden = true

        self.gutImageView.image = #imageLiteral(resourceName: "gut")

        self.magnifierButton.setTitle("", for: .normal)
        self.magnifierButton.addTarget(self, action: #selector(hideOrShowGut), for: .touchUpInside)

        self.notificationLabel.textColor = Palette.darkblue
        self.notificationLabel.numberOfLines = 0
        self.notificationLabel.text = "How's today?"
        self.notificationLabel.font = UIFont(name: "Futura-Bold", size: 25)

        self.startButton.backgroundColor = Palette.darkblue2
        self.startButton.tintColor = Palette.cream
        self.startButton.layer.cornerRadius = self.startButton.frame.height / 2
        self.startButton.setTitle("Start", for: UIControlState.normal)
        self.startButton.titleLabel?.font = UIFont(name: "Futura-Bold", size: 20)

    }

    // MARK : Frequency

    private func detectFrequency() {

        guard let userName = UserDefaults.standard.value(forKey: "Name") as? String else { return }

        CacaProvider.shared.getCaca { (cacas, _) in

            if let cacas = cacas {

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 8)
                var dayToNow = Int()

                guard let lastCacaDate = cacas.last?.date,
                    let date = dateFormatter.date(from: lastCacaDate) else { return }

                dayToNow = date.daysBetweenDate(to: Date())

                if cacas.last?.date == nil {

                    self.notificationLabel.text = "\(userName), start caca now!"

                    self.cacaImageView.image = #imageLiteral(resourceName: "smoothSausage")

                } else if dayToNow > 0 {

                    switch dayToNow {

                    case 1:

                        self.notificationLabel.text = "\(userName), you don't caca today."

                        self.cacaImageView.image = #imageLiteral(resourceName: "smoothSausage")

                    case 2...3:

                        self.notificationLabel.text = "\(userName), you don't caca for \(dayToNow) days. Remember to caca at least every 3 days."

                        self.cacaImageView.image = #imageLiteral(resourceName: "crackSausage")

                    default:

                        self.notificationLabel.text = "\(userName), you don't caca for a long time. Remember to caca at least every 3 days."

                        self.cacaImageView.image = #imageLiteral(resourceName: "lumpySausage")

                    }

                } else if dayToNow == 0 {

                    var todayCacaTimes = 0

                    for caca in cacas {

                        let month = Calendar.current.component(.month, from: Date())
                        let year = Calendar.current.component(.year, from: Date())
                        let day = Calendar.current.component(.day, from: Date())

                        let currentDate = String(format: "%04i-%02i-%02i", year, month, day)

                        if caca.date == currentDate {

                            todayCacaTimes += 1

                        }
                    }

                    if todayCacaTimes > 3 {

                        self.notificationLabel.text = "\(userName), you caca too much today. You should not caca over 3 times per day."

                        self.cacaImageView.image = #imageLiteral(resourceName: "wateryStool")

                    } else {

                        self.notificationLabel.text = "\(userName), you caca today."

                    }
                }
            }
        }
    }

    // MARK : Hide Or Show Gut (Animation)

    func hideOrShowGut() {

        if self.magnifierView.isHidden == true {

            self.magnifierView.transform = self.magnifierView.transform.scaledBy(x: 0.1, y: 0.1)

            UIView.animate(withDuration: 0.5, animations: {

                self.magnifierView.transform = self.magnifierView.transform.scaledBy(x: 10.0, y: 10.0)

                self.magnifierView.isHidden = false

            })

        } else if self.magnifierView.isHidden == false {

            UIView.animate(withDuration: 0.5, animations: {

                self.magnifierView.transform = self.magnifierView.transform.scaledBy(x: 0.1, y: 0.1)

            }, completion: { (_) in

                self.magnifierView.isHidden = true

                self.magnifierView.transform = self.magnifierView.transform.scaledBy(x: 10, y: 10)
            })

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

    func daysBetweenDate(to date: Date) -> Int {

        let components = Calendar.current.dateComponents([.day], from: self, to: date)
        return components.day ?? 0

    }

}
