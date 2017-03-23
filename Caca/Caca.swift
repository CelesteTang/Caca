//
//  Caca.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/23.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import Foundation

class Caca {

    // MARK: Property

    let date: String

    let consumingTime: String

    let shape: Shape

    let color: Color

    let amount: Double

    let otherInfo: String?

    init(date: String, consumingTime: String, shape: Shape, color: Color, amount: Double, otherInfo: String?) {

        self.date = date
        self.consumingTime = consumingTime
        self.shape = shape
        self.color = color
        self.amount = amount
        self.otherInfo = otherInfo
    }

    static var todayCaca = Caca(date: "", consumingTime: "", shape: Shape.smoothSausage, color: Color.lightBrown, amount: 0.0, otherInfo: "")

}
