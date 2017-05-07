//
//  User.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/27.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import Foundation

enum Gender: Int {

    case male, female, personalReasons

    var title: String {

        switch self {
        case .male: return NSLocalizedString("Male", comment: "")
        case .female: return NSLocalizedString("Female", comment: "")
        case .personalReasons: return NSLocalizedString("Personal Reasons", comment: "")
        }

    }

}

enum Medicine: Int {

    case yes, no, personalReasons

    var title: String {

        switch self {
        case .yes: return NSLocalizedString("Yes", comment: "")
        case .no: return NSLocalizedString("No", comment: "")
        case .personalReasons: return NSLocalizedString("Personal Reasons", comment: "")
        }

    }
}

struct User {

    // MARK: Property

    var gender: String = Gender.male.title

    var medicine: String = Medicine.no.title

}
