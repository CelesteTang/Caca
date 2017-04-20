//
//  NumberCollectionViewCell.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/20.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class NumberCollectionViewCell: UICollectionViewCell {

    // MARK: Property

    let itemView = NumberGridView.create()

    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUp()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setUp()

    }

    // MARK: Set Up

    private func setUp() {

        contentView.addSubview(itemView)

    }

}
