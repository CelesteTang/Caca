//
//  SettingRowView.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/20.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class SettingRowView: UIView {

    @IBOutlet weak var titleLabel: UILabel!

}

extension SettingRowView {

    // swiftlint:disable force_cast
    class func create() -> SettingRowView {

        return UINib(nibName: "SettingRowView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! SettingRowView
    }
}
// swiftlint:enable force_cast
