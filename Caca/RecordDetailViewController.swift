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

    @IBOutlet weak var otherInfoLabel: UILabel!

    @IBOutlet weak var passOrFailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        dateLabel.text = Caca.todayCaca.date
        timeLabel.text = Caca.todayCaca.consumingTime
    }

}
