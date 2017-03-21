//
//  RecordTableViewCell.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/21.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class RecordTableViewCell: UITableViewCell {

    // MARK: Property

    static let height: CGFloat = 114.0

    let rowView = RecordRowView.create()

    // MARK: Init

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setUp()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setUp()

    }

    // MARK: Set Up

    private func setUp() {

        clipsToBounds = true

        contentView.addSubview(rowView)

//        rowView.snp.makeConstraints { $0.edges.equalToSuperview() }

    }

}
