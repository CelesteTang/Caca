//
//  ProfileTextFieldRowView.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/27.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class ProfileTextFieldRowView: UIView {
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var infoTextField: UITextField!
    
}

extension ProfileTextFieldRowView {
    
    // swiftlint:disable force_cast
    class func create() -> ProfileTextFieldRowView {
        
        return UINib(nibName: "ProfileTextFieldRowView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! ProfileTextFieldRowView
    }
    // swiftlint:enable force_cast
    
}
