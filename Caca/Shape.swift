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

            return "Separate Hard"

        case .lumpySausage:

            return "Lumpy Sausage"

        case .crackSausage:

            return "Crack Sausage"

        case .smoothSausage:

            return "Smooth Sausage"

        case .softBlob:

            return "Soft Blob"

        case .mushyStool:

            return "Mushy Stool"

        case .wateryStool:

            return "Watery Stool"
        }

    }

    var image: UIImage {

        switch self {
        case .separateHard:

            return #imageLiteral(resourceName: "poo-icon")
            //            return UIImage(named: "")!.withRenderingMode(.alwaysTemplate)

        case .lumpySausage:

            return #imageLiteral(resourceName: "poo-icon")

        case .crackSausage:

            return #imageLiteral(resourceName: "poo-icon")

        case .smoothSausage:

            return #imageLiteral(resourceName: "poo-icon")

        case .softBlob:

            return #imageLiteral(resourceName: "poo-icon")

        case .mushyStool:

            return #imageLiteral(resourceName: "poo-icon")

        case .wateryStool:

            return #imageLiteral(resourceName: "poo-icon")
        }

    }

}
