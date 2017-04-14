//
//  TimingViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/22.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class TimingViewController: UIViewController {

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

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController = UIStoryboard(name: "Fillin", bundle: nil).instantiateViewController(withIdentifier: "FillinViewController") as? FillinViewController
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()

    }

    private func setUp() {
    
        self.timerLabel.font = UIFont(name: "Courier New", size: 35)
        self.timerLabel.textColor = Palette.textColor
        self.timerLabel.text = "00:00:00"
        
        self.startButton.setTitle("Start", for: UIControlState.normal)
        self.pauseButton.setTitle("Pause", for: UIControlState.normal)
        self.resetButton.setTitle("Reset", for: UIControlState.normal)
        self.finishButton.setTitle("Finish", for: UIControlState.normal)
        self.cancelButton.setTitle("Cancel", for: .normal)
        
        self.pauseButton.isEnabled = false
        self.resetButton.isEnabled = false
        
        view.backgroundColor = Palette.backgoundColor
        
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
