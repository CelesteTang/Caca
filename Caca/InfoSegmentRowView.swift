//
//  InfoSegmentRowView.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/29.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class InfoSegmentRowView: UIView {

    @IBOutlet weak var borderView: UIView!

    @IBOutlet weak var infoLabel: UILabel!

    @IBOutlet weak var infoSegmentedControl: UISegmentedControl!

}

extension InfoSegmentRowView {

    // swiftlint:disable force_cast
    class func create() -> InfoSegmentRowView {

        return UINib(nibName: "InfoSegmentRowView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! InfoSegmentRowView
    }
    // swiftlint:enable force_cast

}
