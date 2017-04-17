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

    let photo: String

    let date: String

    let time: String

    let consumingTime: String

    let shape: Shape

    let color: Color

    let amount: Double

    let otherInfo: String?

    let grading: Bool

    let cacaID: String

    let photoID: String

    init(photo: String, date: String, time: String, consumingTime: String, shape: Shape, color: Color, amount: Double, otherInfo: String?, grading: Bool, cacaID: String, photoID: String) {

        self.photo = photo
        self.date = date
        self.time = time
        self.consumingTime = consumingTime
        self.shape = shape
        self.color = color
        self.amount = amount
        self.otherInfo = otherInfo
        self.grading = grading
        self.cacaID = cacaID
        self.photoID = photoID

    }

}
