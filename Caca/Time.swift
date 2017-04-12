//
//  Time.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/23.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import Foundation

class Time {

    static var consumingTime: String = ""

    func dateString() -> String {

        let date = Date()
        let calendar = Calendar.current

        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)

        return String(format: "%04i-%02i-%02i", year, month, day)

    }

    func timeString() -> String {

        let date = Date()
        let calendar = Calendar.current

        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)

        return String(format: "%02i:%02i", hour, minute)

    }
}
