//
//  InfoSegmentTableViewCell.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/29.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class InfoSegmentTableViewCell: UITableViewCell {

    // MARK: Property

    let rowView = InfoSegmentRowView.create()

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

        self.clipsToBounds = true

        self.contentView.addSubview(rowView)

        self.rowView.translatesAutoresizingMaskIntoConstraints = false

        self.rowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        self.rowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        self.rowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        self.rowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true

        self.rowView.backgroundColor = Palette.lightblue2
        self.rowView.borderView.backgroundColor = Palette.darkblue2

    }

}
