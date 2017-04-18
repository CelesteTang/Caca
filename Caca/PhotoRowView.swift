//
//  PhotoRowView.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/18.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class PhotoRowView: UIView {
    
}

extension PhotoRowView {
    
    // swiftlint:disable force_cast
    class func create() -> PhotoRowView {
        
        return UINib(nibName: "PhotoRowView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! PhotoRowView
    }
    // swiftlint:enable force_cast
    
}
