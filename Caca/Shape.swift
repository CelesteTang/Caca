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

            return NSLocalizedString("Separate Hard", comment: "")

        case .lumpySausage:

            return NSLocalizedString("Lumpy Sausage", comment: "")

        case .crackSausage:

            return NSLocalizedString("Crack Sausage", comment: "")

        case .smoothSausage:

            return NSLocalizedString("Smooth Sausage", comment: "")

        case .softBlob:

            return NSLocalizedString("Soft Blob", comment: "")

        case .mushyStool:

            return NSLocalizedString("Mushy Stool", comment: "")

        case .wateryStool:

            return NSLocalizedString("Watery Stool", comment: "")
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
