//
//  FinishRowView.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/18.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class FinishRowView: UIView {
    
}

extension FinishRowView {
    
    // swiftlint:disable force_cast
    class func create() -> FinishRowView {
        
        return UINib(nibName: "FinishRowView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! FinishRowView
    }
    // swiftlint:enable force_cast
    
}
