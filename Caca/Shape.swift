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

            return #imageLiteral(resourceName: "separateHard").withRenderingMode(.alwaysTemplate)

        case .lumpySausage:

            return #imageLiteral(resourceName: "lumpySausage").withRenderingMode(.alwaysTemplate)

        case .crackSausage:

            return #imageLiteral(resourceName: "crackSausage").withRenderingMode(.alwaysTemplate)

        case .smoothSausage:

            return #imageLiteral(resourceName: "smoothSausage").withRenderingMode(.alwaysTemplate)

        case .softBlob:

            return #imageLiteral(resourceName: "softBlob").withRenderingMode(.alwaysTemplate)

        case .mushyStool:

            return #imageLiteral(resourceName: "mushyStool").withRenderingMode(.alwaysTemplate)

        case .wateryStool:

            return #imageLiteral(resourceName: "wateryStool").withRenderingMode(.alwaysTemplate)
        }

    }

}
