//
//  ProfileInfoRowView.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/10.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import Foundation
import UIKit

class ProfileInfoRowView: UIView {

    @IBOutlet weak var infoLabel: UILabel!

}

extension ProfileInfoRowView {

    // swiftlint:disable force_cast
    class func create() -> ProfileInfoRowView {

        return UINib(nibName: "ProfileInfoRowView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! ProfileInfoRowView
    }
}
// swiftlint:enable force_cast
