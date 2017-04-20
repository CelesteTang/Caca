//
//  Authentication.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/20.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

enum Authentication: Int {

    case password, passwordChanging, touchID

    var title: String {

        switch self {

        case .password: return "Password"
        case .passwordChanging: return "New password"
        case .touchID: return "TouchID"

        }
    }

    var switchButton: UISwitch {

        switch self {

        case .password:

            let passwordSwitch = UISwitch()

            passwordSwitch.center = CGPoint(x: PrivacyRowView.create().bounds.width * 0.9, y: PrivacyRowView.create().bounds.height * 0.5)

            return passwordSwitch

        case .passwordChanging:

            let passwordChangingSwitch = UISwitch()

            passwordChangingSwitch.isHidden = true

            return passwordChangingSwitch

        case .touchID:

            let touchIDSwitch = UISwitch()

            touchIDSwitch.center = CGPoint(x: PrivacyRowView.create().bounds.width * 0.9, y: PrivacyRowView.create().bounds.height * 0.5)

            return touchIDSwitch
        }
    }
}
