//
//  RecordRowView.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/20.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class RecordRowView: UIView {

    @IBOutlet weak var cacaPhotoImageView: UIImageView!

    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var passOrFailLabel: UILabel!

}

extension RecordRowView {

    // swiftlint:disable force_cast
    class func create() -> RecordRowView {

        return UINib(nibName: "RecordRowView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! RecordRowView
    }
    // swiftlint:enable force_cast

}
