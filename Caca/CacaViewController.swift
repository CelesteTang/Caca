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
import UserNotifications

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

            let timingViewController = UIStoryboard(name: Constants.Storyboard.timing, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.timing) as? TimingViewController

            FIRAnalytics.logEvent(withName: Constants.FirebaseAnalyticsKey.goToTiming, parameters: nil)

            appDelegate.window?.rootViewController = timingViewController

        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()

        detectFrequency()

        prepareNotification()

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.magnifierView.layer.cornerRadius = self.magnifierView.frame.width / 2
        self.magnifierView.layer.masksToBounds = true

    }

    // MARK: Set Up

    private func setUp() {

        self.navigationItem.title = Time.dateString()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Palette.darkblue, NSFontAttributeName: UIFont(name: Constants.UIFont.futuraBold, size: 20) ?? ""]

        self.view.backgroundColor = Palette.lightblue2

        self.mainImageView.backgroundColor = Palette.lightblue2
        self.mainImageView.image = #imageLiteral(resourceName: "boy")

        UserManager.shared.getUser { (user, _) in

            if let user = user {

                self.mainImageView.image = (user.gender == Gender.male.rawValue) ? #imageLiteral(resourceName: "boy") : #imageLiteral(resourceName: "girl")

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
        self.notificationLabel.text = NSLocalizedString("How's today?", comment: "Greet user")
        self.notificationLabel.font = UIFont(name: Constants.UIFont.futuraBold, size: 25)

        self.startButton.backgroundColor = Palette.darkblue2
        self.startButton.tintColor = Palette.cream
        self.startButton.layer.cornerRadius = self.startButton.frame.height / 2
        self.startButton.setTitle(NSLocalizedString("Start", comment: ""), for: UIControlState.normal)
        self.startButton.titleLabel?.font = UIFont(name: Constants.UIFont.futuraBold, size: 20)

    }

    // MARK : Frequency

    private func detectFrequency() {

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

                    self.notificationLabel.text = NSLocalizedString(", start caca now!", comment: "")

                    self.cacaImageView.image = #imageLiteral(resourceName: "smoothSausage")

                } else if dayToNow > 0 {

                    switch dayToNow {

                    case 1:

                        self.notificationLabel.text = NSLocalizedString(", you don't caca today.", comment: "")

                        self.cacaImageView.image = #imageLiteral(resourceName: "smoothSausage")

                    case 2...3:

                        let notificationString = NSLocalizedString(", you don't caca for %d days. Remember to caca at least every 3 days.", comment: "")
                        self.notificationLabel.text = String(format: notificationString, dayToNow)

                        self.cacaImageView.image = #imageLiteral(resourceName: "crackSausage")

                    default:

                        self.notificationLabel.text = NSLocalizedString(", you don't caca for a long time. Remember to caca at least every 3 days.", comment: "")

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

                        self.notificationLabel.text = NSLocalizedString(", you caca too much today. You should not caca over 3 times per day.", comment: "")

                        self.cacaImageView.image = #imageLiteral(resourceName: "wateryStool")

                    } else {

                        self.notificationLabel.text = NSLocalizedString(", you caca today.", comment: "")

                    }
                }
            }
        }
    }

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

    // MARK : Notification

    func prepareNotification() {

        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("Notification", comment: "")
        content.body = NSLocalizedString("You don't caca for 3 days. Remember to caca at least every 3 days.", comment: "Remind user to caca")
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3 * 24 * 60 * 60, repeats: false)
        let request = UNNotificationRequest(identifier: Constants.NotificationIdentidier.longTimeNoCaca, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

extension CacaViewController {

    // swiftlint:disable force_cast
    class func create() -> CacaViewController {

        return UIStoryboard(name: Constants.Storyboard.caca, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.caca) as! CacaViewController

    }
    // swiftlint:enable force_cast

}

extension Date {

    func daysBetweenDate(to date: Date) -> Int {

        let components = Calendar.current.dateComponents([.day], from: self, to: date)
        return components.day ?? 0

    }

}
