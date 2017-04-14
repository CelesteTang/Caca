//
//  RecordDetailViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/23.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class RecordDetailViewController: UIViewController {

    @IBOutlet weak var cacaPhoto: UIImageView!

    @IBOutlet weak var deleteRecordButton: UIButton!

    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var consumingTimeLabel: UILabel!

    @IBOutlet weak var shapeImageView: UIImageView!

    @IBOutlet weak var colorImageView: UIImageView!

    @IBOutlet weak var amountLabel: UILabel!

    @IBOutlet weak var otherInfoLabel: UILabel!

    @IBOutlet weak var passOrFailLabel: UILabel!

    @IBAction func deleteRecord(_ sender: UIButton) {

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
           let tabBarController = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? TabBarController {

            tabBarController.selectedIndex = TabBarItemType.record.rawValue

            CacaProvider.shared.deleteCaca(of: recievedCaca[0].cacaID)

            appDelegate.window?.rootViewController = tabBarController
        }

    }

    var recievedCaca = [Caca]()
    var indexPath = IndexPath()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()

        if recievedCaca[0].photo != "" {

            DispatchQueue.global().async {
                if let url = URL(string: self.recievedCaca[0].photo) {

                    do {
                        let data = try Data(contentsOf: url)
                        let image = UIImage(data: data)

                        DispatchQueue.main.async {
                            self.cacaPhoto.image = image
                        }

                    } catch {

                        print(error)

                    }
                }
            }
        }

        if recievedCaca[0].grading == true {

            passOrFailLabel.text = "Pass"
            passOrFailLabel.backgroundColor = Palette.passColor

        } else {

            passOrFailLabel.text = "Fail"
            passOrFailLabel.backgroundColor = Palette.failColor

        }

        tabBarController?.tabBar.isHidden = true
    }

    // MARK: Set Up

    private func setUp() {

        view.backgroundColor = Palette.backgoundColor

        cacaPhoto.backgroundColor = Palette.backgoundColor
        shapeImageView.backgroundColor = Palette.backgoundColor
        colorImageView.backgroundColor = Palette.backgoundColor

        cacaPhoto.image = #imageLiteral(resourceName: "poo-icon")

        deleteRecordButton.setTitle("Delete", for: .normal)
        dateLabel.text = recievedCaca[0].date
        timeLabel.text = recievedCaca[0].time
        consumingTimeLabel.text = recievedCaca[0].consumingTime
        shapeImageView.image = recievedCaca[0].shape.image
        colorImageView.image = recievedCaca[0].color.image
        amountLabel.text = String(recievedCaca[0].amount)
        otherInfoLabel.text = recievedCaca[0].otherInfo
        passOrFailLabel.textColor = Palette.backgoundColor
        passOrFailLabel.layer.cornerRadius = 15

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        tabBarController?.tabBar.isHidden = false

    }
}
