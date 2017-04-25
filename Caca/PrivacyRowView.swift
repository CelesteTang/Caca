//
//  PrivacyRowView.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/11.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class PrivacyRowView: UIView {

    @IBOutlet weak var privacyLabel: UILabel!

    @IBOutlet weak var switchButton: UISwitch!
}

extension PrivacyRowView {

    // swiftlint:disable force_cast
    class func create() -> PrivacyRowView {

        return UINib(nibName: "PrivacyRowView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! PrivacyRowView
    }
    // swiftlint:enable force_cast

}
