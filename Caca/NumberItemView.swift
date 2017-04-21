//
//  NumberItemView.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/20.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class NumberItemView: UIView {

    @IBOutlet weak var numberLabel: UILabel!

}

extension NumberItemView {

    // swiftlint:disable force_cast
    class func create() -> NumberItemView {

        return UINib(nibName: "NumberItemView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! NumberItemView
    }
    // swiftlint:enable force_cast

}
