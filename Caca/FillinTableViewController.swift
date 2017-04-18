//
//  FillinTableViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/18.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class FillinTableViewController: UITableViewController {

    enum Component {
        
        case photo, info, finish
        
    }
    
    // MARK: Property
    
    var components: [Component] = [.photo, .info, .info, .info, .info, .info, .finish]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: "PhotoTableViewCell")
        self.tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: "InfoTableViewCell")
        self.tableView.register(FinishTableViewCell.self, forCellReuseIdentifier: "FinishTableViewCell")

        self.tableView.allowsSelection = false
        self.tableView.separatorStyle = .none
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return components.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let component = components[section]
        
        switch component {
            
        case .photo, .info, .finish:
            
            return 1
            
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let component = components[indexPath.section]
        
        switch component {
            
        case .photo:
            return 150.0
            
        case .info, .finish:
            return 100.0
            
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let component = components[indexPath.section]
        
        switch component {
            
        case .photo:
            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell", for: indexPath) as! PhotoTableViewCell
            // swiftlint:enable force_cast
            cell.rowView.cacaPhotoImageView.backgroundColor = .gray
            return cell
        case .info:
            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewCell", for: indexPath) as! InfoTableViewCell
            // swiftlint:enable force_cast
            return cell
        case .finish:
            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "FinishTableViewCell", for: indexPath) as! FinishTableViewCell
            // swiftlint:enable force_cast
            return cell
        }
    }

}
