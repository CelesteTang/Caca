//
//  User.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/27.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import Foundation

enum Gender: Int {

    case male, female

}

enum Medicine: Int {

    case yes, no

}

struct User {

    // MARK: Property

    var gender: Int = Gender.male.rawValue

    var medicine: Int = Medicine.no.rawValue

    static var host = User()
    
}
