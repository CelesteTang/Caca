//
//  ProfileTableViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/27.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    let agePicker = UIPickerView()

    var age = [Int]()

    enum Component: Int {

        case photo, name, gender, age, medicine, finish

        var title: String {

            switch self {
            case .name:
                return "Name"
            case .gender:
                return "Gender"
            case .age:
                return "Age"
            case .medicine:
                return "Medicine"
            default:
                return ""
            }
        }
    }

    // MARK: Property

    let components: [Component] = [.photo, .name, .gender, .age, .medicine, .finish]

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()

        self.tableView.register(ProfilePhotoTableViewCell.self, forCellReuseIdentifier: "ProfilePhotoTableViewCell")
        self.tableView.register(ProfileTextFieldTableViewCell.self, forCellReuseIdentifier: "ProfileTextFieldTableViewCell")
        self.tableView.register(ProfileSegmentTableViewCell.self, forCellReuseIdentifier: "ProfileSegmentTableViewCell")
        self.tableView.register(ProfileButtonTableViewCell.self, forCellReuseIdentifier: "ProfileButtonTableViewCell")

        self.tableView.allowsSelection = false
        self.tableView.separatorStyle = .none

    }

    // MARK: Set Up

    private func setUp() {

        self.tableView.backgroundColor = Palette.lightblue2

        self.navigationItem.title = "Profile"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Palette.darkblue, NSFontAttributeName: UIFont(name: "Futura-Bold", size: 20) ?? ""]

        self.agePicker.dataSource = self
        self.agePicker.delegate = self
        for i in 0...123 { age.append(i) }

        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)

    }

    func hideKeyBoard() {

        self.tableView.endEditing(true)

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}

extension ProfileTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {

        switch pickerView {

        case agePicker: return 1

        default: return 1

        }

    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        switch pickerView {

        case agePicker:

            return age.count

        default: return 0

        }

    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if let ageCell = tableView.visibleCells[Component.age.rawValue] as? InfoTableViewCell {

            switch pickerView {

            case agePicker:

                ageCell.rowView.infoTextField.text = String(age[row])

            default: break

            }
        }

    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        switch pickerView {

        case agePicker:

            let pickerLabel = UILabel()

            pickerLabel.text = String(age[row])

            pickerLabel.font = UIFont(name: "Futura-Bold", size: 20)

            pickerLabel.textAlignment = NSTextAlignment.center

            return pickerLabel

        default:

            let view = UIView()

            view.isHidden = true

            return view

        }

    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {

        return 50.0
    }

}
