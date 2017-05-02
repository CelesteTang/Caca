//
//  Shape.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/19.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

enum Shape: Int {

    case separateHard, lumpySausage, crackSausage, smoothSausage, softBlob, mushyStool, wateryStool

    var title: String {

        switch self {
        case .separateHard:

            return Constants.Shape.separateHard

        case .lumpySausage:

            return Constants.Shape.lumpySausage

        case .crackSausage:

            return Constants.Shape.crackSausage

        case .smoothSausage:

            return Constants.Shape.smoothSausage

        case .softBlob:

            return Constants.Shape.softBlob

        case .mushyStool:

            return Constants.Shape.mushyStool

        case .wateryStool:

            return Constants.Shape.wateryStool
        }

    }

    var image: UIImage {

        switch self {
        case .separateHard:

            return #imageLiteral(resourceName: "separateHard")

        case .lumpySausage:

            return #imageLiteral(resourceName: "lumpySausage")

        case .crackSausage:

            return #imageLiteral(resourceName: "crackSausage")

        case .smoothSausage:

            return #imageLiteral(resourceName: "smoothSausage")

        case .softBlob:

            return #imageLiteral(resourceName: "softBlob")

        case .mushyStool:

            return #imageLiteral(resourceName: "mushyStool")

        case .wateryStool:

            return #imageLiteral(resourceName: "wateryStool")
        }

    }

}
