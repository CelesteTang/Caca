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

        case .password: return NSLocalizedString("Password", comment: "")

        case .passwordChanging: return NSLocalizedString("New password", comment: "")

        case .touchID: return "TouchID"

        }
    }
}
