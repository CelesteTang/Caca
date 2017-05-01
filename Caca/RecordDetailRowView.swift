//
//  RecordDetailRowView.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/5/1.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class RecordDetailRowView: UIView {

    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var infoTextLabel: UILabel!

}

extension RecordDetailRowView {
    
    // swiftlint:disable force_cast
    class func create() -> RecordDetailRowView {
        
        return UINib(nibName: "RecordDetailRowView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! RecordDetailRowView
    }
    // swiftlint:enable force_cast
    
}
