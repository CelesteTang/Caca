//
//  ProfileTableViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/10.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    enum Component {

        case photo, info

    }

    // MARK: Property

    private let components: [Component] = [ .photo, .info, .info, .info ]

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
        
    }

    // MARK: Set Up

    private func setUp() {

        tableView.keyboardDismissMode = .onDrag
        tableView.backgroundColor = Palette.backgoundColor
        tableView.separatorStyle = .none

        tableView.register(ProfilePhotoTableViewCell.self, forCellReuseIdentifier: "ProfilePhotoTableViewCell")
        tableView.register(ProfileInfoTableViewCell.self, forCellReuseIdentifier: "ProfileInfoTableViewCell")

    }

    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return components.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch components[section] {
        case .photo, .info:

            return 1
        }

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // swiftlint:disable force_cast
        switch components[indexPath.section] {
        case .photo:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilePhotoTableViewCell", for: indexPath) as! ProfilePhotoTableViewCell
            cell.contentView.backgroundColor = Palette.backgoundColor
            return cell
        case .info:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfoTableViewCell", for: indexPath) as! ProfileInfoTableViewCell
            cell.contentView.backgroundColor = Palette.textColor
            return cell
        }
        // swiftlint:enable force_case

    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch components[indexPath.section] {
        case .photo:
            return 300.0
        case .info:
            return 121.0
        }

    }
}
