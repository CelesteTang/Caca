//
//  TimingViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/22.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

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

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? TabBarController {

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

            self.pauseButton.setTitle("Resume", for: UIControlState.normal)

        } else {

            runTimer()

            self.resumeTapped = false

            self.pauseButton.setTitle("Pause", for: UIControlState.normal)

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

        self.pauseButton.setTitle("Pause", for: UIControlState.normal)

    }

    @IBAction func finishButtonTapped(_ sender: UIButton) {

        timer.invalidate()

        Time.consumingTime = timeString(time: TimeInterval(seconds))

        let fillinStorybard = UIStoryboard(name: "Fillin", bundle: nil)

        guard let fillinTableViewController = fillinStorybard.instantiateViewController(withIdentifier: "FillinTableViewController") as? FillinTableViewController else { return }

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

            appDelegate.window?.rootViewController = fillinTableViewController

            fillinTableViewController.isFromCaca = true

        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()

    }

    // MARK: Set Up

    private func setUp() {

        self.view.backgroundColor = Palette.lightblue2

        self.backgroundImageView.image = #imageLiteral(resourceName: "toilet-7+")

        self.timerLabel.font = UIFont(name: "Courier New", size: 35)
        self.timerLabel.textColor = Palette.darkblue
        self.timerLabel.text = "00:00:00"

        self.startButton.setTitle(" Start ", for: UIControlState.normal)
        self.startButton.titleLabel?.font = UIFont(name: "Futura-Bold", size: 20)
        self.startButton.tintColor = Palette.orange
        self.startButton.backgroundColor = Palette.lightWhite
        self.startButton.layer.cornerRadius = 10
        
        self.pauseButton.setTitle(" Pause ", for: UIControlState.normal)
        self.pauseButton.titleLabel?.font = UIFont(name: "Futura-Bold", size: 20)
        self.pauseButton.tintColor = Palette.orange
        self.pauseButton.backgroundColor = Palette.lightWhite
        self.pauseButton.layer.cornerRadius = 10
        
        self.resetButton.setTitle(" Reset ", for: UIControlState.normal)
        self.resetButton.titleLabel?.font = UIFont(name: "Futura-Bold", size: 20)
        self.resetButton.tintColor = Palette.orange
        self.resetButton.backgroundColor = Palette.lightWhite
        self.resetButton.layer.cornerRadius = 10
        
        self.finishButton.setTitle(" Finish ", for: UIControlState.normal)
        self.finishButton.titleLabel?.font = UIFont(name: "Futura-Bold", size: 20)
        self.finishButton.tintColor = Palette.orange
        self.finishButton.backgroundColor = Palette.lightWhite
        self.finishButton.layer.cornerRadius = 10

        self.cancelButton.setTitle("", for: .normal)
        let buttonimage = #imageLiteral(resourceName: "cancel").withRenderingMode(.alwaysTemplate)
        self.cancelButton.setImage(buttonimage, for: .normal)
        self.cancelButton.tintColor = Palette.darkblue
//        self.cancelButton.backgroundColor = Palette.lightblue2
//        self.cancelButton.layer.cornerRadius = self.cancelButton.frame.width / 2
//        self.cancelButton.layer.masksToBounds = true

        self.pauseButton.isEnabled = false
        self.resetButton.isEnabled = false

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
