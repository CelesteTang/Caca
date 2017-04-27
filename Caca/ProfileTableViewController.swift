//
//  ProfileTableViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/27.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit
import Firebase

class ProfileTableViewController: UITableViewController {

    let agePicker = UIPickerView()

    var age = [Int]()

    var user = User(name: "", gender: 0, age: "", medicine: false)

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

        self.view.endEditing(true)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.isHidden = true

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        tabBarController?.tabBar.isHidden = false

//        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
//        let value = ["name": nameTextField.text ?? "Hello",
//                     "gender": genderSegmentedControl.selectedSegmentIndex,
//                     "age": ageTextField.text ?? "??"] as [String: Any]
//        
//        UserManager.shared.editUser(with: uid, value: value)
//        
//        UserDefaults.standard.set(nameTextField.text, forKey: "Name")
//        UserDefaults.standard.set(genderSegmentedControl.selectedSegmentIndex, forKey: "Gender")
//        UserDefaults.standard.set(ageTextField.text, forKey: "Age")

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return components.count

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let component = components[section]

        switch component {

        case .photo, .name, .gender, .age, .medicine, .finish:

            return 1

        }

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let component = components[indexPath.section]

        switch component {

        case .photo:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilePhotoTableViewCell", for: indexPath) as! ProfilePhotoTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.photoImageView.image = #imageLiteral(resourceName: "boy")

            if let gender = UserDefaults.standard.value(forKey: "Gender") as? Int {

                if gender == Gender.male.rawValue {

                    cell.rowView.photoImageView.image = #imageLiteral(resourceName: "boy")

                } else if gender == Gender.female.rawValue {

                    cell.rowView.photoImageView.image = #imageLiteral(resourceName: "girl")

                }

            }

            return cell

        case .name:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTextFieldTableViewCell", for: indexPath) as! ProfileTextFieldTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.infoLabel.text = component.title
            cell.rowView.infoTextField.delegate = self
            cell.rowView.infoTextField.returnKeyType = .done

            return cell

        case .gender:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileSegmentTableViewCell", for: indexPath) as! ProfileSegmentTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.infoLabel.text = component.title

            let maleImage = resizeImage(image: #imageLiteral(resourceName: "male"), targetRatio: 0.5)
            let femaleImage = resizeImage(image: #imageLiteral(resourceName: "female"), targetRatio: 0.5)
            cell.rowView.infoSegmentedControl.setImage(maleImage, forSegmentAt: Gender.male.rawValue)
            cell.rowView.infoSegmentedControl.setImage(femaleImage, forSegmentAt: Gender.female.rawValue)
            cell.rowView.infoSegmentedControl.tintColor = Palette.darkblue
            cell.rowView.infoSegmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName: Palette.darkblue, NSFontAttributeName: UIFont(name: "Futura-Bold", size: 20) ?? ""], for: .normal)
            cell.rowView.infoSegmentedControl.addTarget(self, action: #selector(changeGender), for: .valueChanged)

            cell.rowView.infoSegmentedControl.selectedSegmentIndex = 0

            return cell

        case .age:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTextFieldTableViewCell", for: indexPath) as! ProfileTextFieldTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.infoLabel.text = component.title
            cell.rowView.infoTextField.delegate = self
            cell.rowView.infoTextField.returnKeyType = .done

            cell.rowView.infoTextField.inputView = agePicker

            return cell

        case .medicine:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileSegmentTableViewCell", for: indexPath) as! ProfileSegmentTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.infoLabel.text = component.title

            return cell

        case .finish:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileButtonTableViewCell", for: indexPath) as! ProfileButtonTableViewCell
            // swiftlint:enable force_cast

            return cell

        }

    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let component = components[indexPath.section]

        switch component {

        case .photo:

            return 200.0

        case .name, .gender, .age, .medicine:

            return 80.0

        case .finish:

            return 100.0

        }
    }

    func resizeImage(image: UIImage, targetRatio: CGFloat) -> UIImage {

        let size = image.size

        let newSize = CGSize(width: size.width * targetRatio, height: size.height * targetRatio)

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)

        image.draw(in: rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return newImage!
    }

    func changeGender() {

        if let photoCell = tableView.visibleCells[Component.photo.rawValue] as? ProfilePhotoTableViewCell,
           let genderCell = tableView.visibleCells[Component.gender.rawValue] as? ProfileSegmentTableViewCell {

            if genderCell.rowView.infoSegmentedControl.selectedSegmentIndex == Gender.male.rawValue {

                photoCell.rowView.photoImageView.image = #imageLiteral(resourceName: "boy")

            } else if genderCell.rowView.infoSegmentedControl.selectedSegmentIndex == Gender.female.rawValue {

                photoCell.rowView.photoImageView.image = #imageLiteral(resourceName: "girl")

            }
        }

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

extension ProfileTableViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        self.view.endEditing(true)

        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {

        self.view.endEditing(true)

        return true
    }

}
