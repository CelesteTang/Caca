//
//  Caca.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/23.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import Foundation
import UIKit

class Caca {

    // MARK: Property

    let cacaID: String

    let photo: String

    let photoID: String

    let date: String

    let time: String

    let consumingTime: String

    let shape: String

    let color: String

    let amount: String

    let otherInfo: String?

    let grading: Bool

    let advice: String

    init(cacaID: String, photo: String, photoID: String, date: String, time: String, consumingTime: String, shape: String, color: String, amount: String, otherInfo: String?, grading: Bool, advice: String) {

        self.cacaID = cacaID
        self.photo = photo
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

    }

}

class FinalCaca {

    // MARK: Property

    let date: String

    let time: String

    let consumingTime: String

    let shape: String

    let color: String

    let amount: String

    let otherInfo: String?

    var image: UIImage

    init(date: String, time: String, consumingTime: String, shape: String, color: String, amount: String, otherInfo: String?, image: UIImage) {

        self.date = date
        self.time = time
        self.consumingTime = consumingTime
        self.shape = shape
        self.color = color
        self.amount = amount
        self.otherInfo = otherInfo
        self.image = image

    }

}
