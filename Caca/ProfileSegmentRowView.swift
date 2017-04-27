//
//  ProfileSegmentRowView.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/27.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class ProfileSegmentRowView: UIView {

    @IBOutlet weak var infoLabel: UILabel!

    @IBOutlet weak var infoSegmentedControl: UISegmentedControl!

}

extension ProfileSegmentRowView {

    // swiftlint:disable force_cast
    class func create() -> ProfileSegmentRowView {

        return UINib(nibName: "ProfileSegmentRowView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! ProfileSegmentRowView
    }
    // swiftlint:enable force_cast

}
