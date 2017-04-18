//
//  InfoRowView.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/18.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class InfoRowView: UIView {

    @IBOutlet weak var borderView: UIView!

    @IBOutlet weak var infoLabel: UILabel!

    @IBOutlet weak var infoTextField: UITextField!
}

extension InfoRowView {

    // swiftlint:disable force_cast
    class func create() -> InfoRowView {

        return UINib(nibName: "InfoRowView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! InfoRowView
    }
    // swiftlint:enable force_cast

}
