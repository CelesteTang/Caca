//
//  ProfilePhotoRowView.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/27.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class ProfilePhotoRowView: UIView {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
}

extension ProfilePhotoRowView {
    
    // swiftlint:disable force_cast
    class func create() -> ProfilePhotoRowView {
        
        return UINib(nibName: "ProfilePhotoRowView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! ProfilePhotoRowView
    }
    // swiftlint:enable force_cast
    
}
