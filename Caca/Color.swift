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

            return NSLocalizedString("Red", comment: "")

        case .yellow:

            return NSLocalizedString("Yellow", comment: "")

        case .green:

            return NSLocalizedString("Green", comment: "")

        case .lightBrown:

            return NSLocalizedString("Light Brown", comment: "")

        case .darkBrown:

            return NSLocalizedString("Dark Brown", comment: "")

        case .gray:

            return NSLocalizedString("Gray", comment: "")

        case .black:

            return NSLocalizedString("Black", comment: "")
        }

    }

    var image: UIImage {

        switch self {

        case .red:

            return #imageLiteral(resourceName: "red")

        case .yellow:

            return #imageLiteral(resourceName: "yellow")

        case .green:

            return #imageLiteral(resourceName: "green")

        case .lightBrown:

            return #imageLiteral(resourceName: "lightBrown")

        case .darkBrown:

            return #imageLiteral(resourceName: "darkBrown")

        case .gray:

            return #imageLiteral(resourceName: "gray")

        case .black:

            return #imageLiteral(resourceName: "black")
        }

    }

    var color: UIColor {

        switch self {

        case .red:

            return Palette.red

        case .yellow:

            return Palette.yellow

        case .green:

            return Palette.green

        case .lightBrown:

            return Palette.lightBrown

        case .darkBrown:

            return Palette.darkBrown

        case .gray:

            return Palette.gray

        case .black:

            return Palette.black
        }

    }

}
