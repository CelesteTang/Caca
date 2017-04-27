//
//  User.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/27.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import Foundation

class User {

    // MARK: Property

    let name: String

    let gender: Int

    let age: String

    let medicine: Bool

    init(name: String, gender: Int, age: String, medicine: Bool) {

        self.name = name
        self.gender = gender
        self.age = age
        self.medicine = medicine

    }

}
