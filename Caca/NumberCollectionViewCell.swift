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

    let itemView = NumberItemView.create()

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

        self.itemView.translatesAutoresizingMaskIntoConstraints = false

        self.itemView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        self.itemView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        self.itemView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        self.itemView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true

        self.itemView.backgroundColor = Palette.lightblue2

    }

}
