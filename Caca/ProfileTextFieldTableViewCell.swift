//
//  ProfileTextFieldTableViewCell.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/27.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class ProfileTextFieldTableViewCell: UITableViewCell {

    // MARK: Property

    let rowView = ProfileTextFieldRowView.create()

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

        rowView.translatesAutoresizingMaskIntoConstraints = false

        rowView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        rowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        rowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        rowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true

        rowView.backgroundColor = Palette.lightblue2

    }
}
