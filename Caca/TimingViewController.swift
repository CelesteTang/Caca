//
//  TimingViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/22.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit
import Firebase

class TimingViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!

    @IBOutlet weak var cancelButton: UIButton!

    @IBOutlet weak var timerLabel: UILabel!

    @IBOutlet weak var startButton: UIButton!

    @IBOutlet weak var pauseButton: UIButton!

    @IBOutlet weak var resetButton: UIButton!

    @IBOutlet weak var finishButton: UIButton!

    var seconds: UInt = 0

    var timer = Timer()

    var isTimerRunning = false

    var resumeTapped = false

    @IBAction func cancelTiming(_ sender: UIButton) {

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

            let tabBarController = UIStoryboard(name: Constants.Storyboard.tabBar, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.tabBar) as? TabBarController

            FIRAnalytics.logEvent(withName: Constants.FirebaseAnalyticsKey.cancelTiming, parameters: nil)

            appDelegate.window?.rootViewController = tabBarController

        }

    }

    @IBAction func startButtonTapped(_ sender: UIButton) {

        if isTimerRunning == false {

            runTimer()

            self.startButton.isEnabled = false
            self.resetButton.isEnabled = true

        }

    }

    @IBAction func pauseButtonTapped(_ sender: UIButton) {

        if self.resumeTapped == false {

            timer.invalidate()

            self.resumeTapped = true

            self.pauseButton.setTitle(NSLocalizedString(" Resume ", comment: ""), for: UIControlState.normal)

        } else {

            runTimer()

            self.resumeTapped = false

            self.pauseButton.setTitle(NSLocalizedString(" Pause ", comment: ""), for: UIControlState.normal)

        }
    }

    @IBAction func resetButtonTapped(_ sender: UIButton) {

        timer.invalidate()

        seconds = 0

        timerLabel.text = "00:00:00"

        isTimerRunning = false

        resumeTapped = false

        self.pauseButton.isEnabled = false

        self.startButton.isEnabled = true

        self.pauseButton.setTitle(NSLocalizedString(" Pause ", comment: ""), for: UIControlState.normal)

    }

    @IBAction func finishButtonTapped(_ sender: UIButton) {

        timer.invalidate()

        Time.consumingTime = timeString(time: TimeInterval(seconds))

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

            let fillinTableViewController = UIStoryboard(name: Constants.Storyboard.fillin, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.fillin) as? FillinTableViewController

            fillinTableViewController?.isFromCaca = true

            FIRAnalytics.logEvent(withName: Constants.FirebaseAnalyticsKey.didTiming, parameters: nil)

            appDelegate.window?.rootViewController = fillinTableViewController

        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()

    }

    // MARK: Set Up

    private func setUp() {

        self.view.backgroundColor = Palette.lightblue2

        self.backgroundImageView.image = #imageLiteral(resourceName: "POO-24")

        self.timerLabel.font = UIFont(name: Constants.UIFont.courierNew, size: 35)
        self.timerLabel.textColor = Palette.darkblue
        self.timerLabel.text = "00:00:00"

        self.startButton.setTitle(NSLocalizedString(" Start ", comment: ""), for: .normal)
        self.startButton.titleLabel?.font = UIFont(name: Constants.UIFont.futuraBold, size: 20)
        self.startButton.tintColor = Palette.orange
        self.startButton.backgroundColor = Palette.lightWhite
        self.startButton.layer.cornerRadius = 10

        self.pauseButton.setTitle(NSLocalizedString(" Pause ", comment: ""), for: .normal)
        self.pauseButton.titleLabel?.font = UIFont(name: Constants.UIFont.futuraBold, size: 20)
        self.pauseButton.tintColor = Palette.orange
        self.pauseButton.backgroundColor = Palette.lightWhite
        self.pauseButton.layer.cornerRadius = 10
        self.pauseButton.isEnabled = false

        self.resetButton.setTitle(NSLocalizedString(" Reset ", comment: ""), for: .normal)
        self.resetButton.titleLabel?.font = UIFont(name: Constants.UIFont.futuraBold, size: 20)
        self.resetButton.tintColor = Palette.orange
        self.resetButton.backgroundColor = Palette.lightWhite
        self.resetButton.layer.cornerRadius = 10
        self.resetButton.isEnabled = false

        self.finishButton.setTitle(NSLocalizedString(" Finish ", comment: ""), for: UIControlState.normal)
        self.finishButton.titleLabel?.font = UIFont(name: Constants.UIFont.futuraBold, size: 20)
        self.finishButton.tintColor = Palette.orange
        self.finishButton.backgroundColor = Palette.lightWhite
        self.finishButton.layer.cornerRadius = 10

        self.cancelButton.setTitle("", for: .normal)
        let buttonimage = #imageLiteral(resourceName: "cancel").withRenderingMode(.alwaysTemplate)
        self.cancelButton.setImage(buttonimage, for: .normal)
        self.cancelButton.tintColor = Palette.darkblue

    }

    func runTimer() {

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimingViewController.updateTimer), userInfo: nil, repeats: true)

        isTimerRunning = true

        self.pauseButton.isEnabled = true

    }

    func updateTimer() {

        seconds += 1
        timerLabel.text = timeString(time: TimeInterval(seconds))
    }

    func timeString(time: TimeInterval) -> String {

        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60

        return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
    }
}
