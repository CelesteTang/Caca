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

            return Constants.Color.red

        case .yellow:

            return Constants.Color.yellow

        case .green:

            return Constants.Color.green

        case .lightBrown:

            return Constants.Color.lightBrown

        case .darkBrown:

            return Constants.Color.darkBrown

        case .gray:

            return Constants.Color.gray

        case .black:

            return Constants.Color.black
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
