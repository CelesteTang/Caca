//
//  ProfileButtonRowView.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/27.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class ProfileButtonRowView: UIView {
    
    
}

extension ProfileButtonRowView {
    
    // swiftlint:disable force_cast
    class func create() -> ProfileButtonRowView {
        
        return UINib(nibName: "ProfileButtonRowView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! ProfileButtonRowView
    }
    // swiftlint:enable force_cast
    
}
