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

    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var consumingTimeLabel: UILabel!

    @IBOutlet weak var shapeImageView: UIImageView!

    @IBOutlet weak var colorImageView: UIImageView!

    @IBOutlet weak var amountLabel: UILabel!

    @IBOutlet weak var otherInfoLabel: UILabel!

    @IBOutlet weak var passOrFailLabel: UILabel!

    var recievedCaca = [Caca]()

    override func viewDidLoad() {
        super.viewDidLoad()

        if recievedCaca[0].photo != "" {

            if let url = URL(string: recievedCaca[0].photo) {

                do {
                    let data = try Data(contentsOf: url)
                    cacaPhoto.image = UIImage(data: data)
                    
                } catch {
                    
                    print(error)
                    
                }
            }
        } else {

            cacaPhoto.image = #imageLiteral(resourceName: "poo-icon")

        }

        dateLabel.text = recievedCaca[0].date
        timeLabel.text = recievedCaca[0].time
        consumingTimeLabel.text = recievedCaca[0].consumingTime
        shapeImageView.image = recievedCaca[0].shape.image
        colorImageView.image = recievedCaca[0].color.image
        amountLabel.text = String(recievedCaca[0].amount)
        otherInfoLabel.text = recievedCaca[0].otherInfo

        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
}
