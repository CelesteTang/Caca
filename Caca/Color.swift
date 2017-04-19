//
//  Color.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/19.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

enum Color: Int {

    case red, yellow, green, lightBrown, darkBrown, gray, black

    var title: String {

        switch self {
        case .red:

            return "Red"

        case .yellow:

            return "Yellow"
        case .green:

            return "Green"

        case .lightBrown:

            return "Light Brown"

        case .darkBrown:

            return "Dark Brown"

        case .gray:

            return "Gray"

        case .black:

            return "Black"
        }

    }

    var image: UIImage {

        switch self {
        case .red:

            return #imageLiteral(resourceName: "poo-icon")

        case .yellow:

            return #imageLiteral(resourceName: "poo-icon")
        case .green:

            return #imageLiteral(resourceName: "poo-icon")

        case .lightBrown:

            return #imageLiteral(resourceName: "poo-icon")

        case .darkBrown:

            return #imageLiteral(resourceName: "poo-icon")

        case .gray:

            return #imageLiteral(resourceName: "poo-icon")

        case .black:

            return #imageLiteral(resourceName: "poo-icon")
        }

    }

}
