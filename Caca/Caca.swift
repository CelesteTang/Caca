//
//  Caca.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/23.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Caca {

    // MARK: Property

    let cacaID: String

    var photoURL: String?

    var photoID: String?

    var date: String

    var time: String

    var consumingTime: String

    var shape: String

    var color: String

    var amount: String

    var otherInfo: String?

    var grading: Bool

    var advice: String

    var period: Int?

    var medicine: String?

    var image: UIImage

    init(cacaID: String, photoURL: String? = nil, photoID: String? = nil, date: String, time: String, consumingTime: String, shape: String, color: String, amount: String, otherInfo: String? = nil, grading: Bool, advice: String, period: Int? = nil, medicine: String? = nil) {

        self.cacaID = cacaID
        self.photoURL = photoURL
        self.photoID = photoID
        self.date = date
        self.time = time
        self.consumingTime = consumingTime
        self.shape = shape
        self.color = color
        self.amount = amount
        self.otherInfo = otherInfo
        self.grading = grading
        self.advice = advice
        self.period = period
        self.medicine = medicine
        self.image = #imageLiteral(resourceName: "cacaWithCamera")

    }

}
