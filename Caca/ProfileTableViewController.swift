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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.isHidden = true

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        tabBarController?.tabBar.isHidden = false

        if let uid = FIRAuth.auth()?.currentUser?.uid,
           let nameCell = tableView.visibleCells[Component.name.rawValue] as? ProfileTextFieldTableViewCell,
           let genderCell = tableView.visibleCells[Component.gender.rawValue] as? ProfileSegmentTableViewCell,
           let ageCell = tableView.visibleCells[Component.age.rawValue] as? ProfileTextFieldTableViewCell,
           let medicineCell = tableView.visibleCells[Component.gender.rawValue] as? ProfileSegmentTableViewCell {

            let name = nameCell.rowView.infoTextField.text ?? "Hello"
            let gender = genderCell.rowView.infoSegmentedControl.selectedSegmentIndex
            let age = ageCell.rowView.infoTextField.text ?? "??"
            let medicine = medicineCell.rowView.infoSegmentedControl.selectedSegmentIndex

            let user = User(name: name, gender: gender, age: age, medicine: medicine)

            let value = ["name": user.name,
                         "gender": user.gender,
                         "age": user.age,
                         "medicine": user.medicine] as [String: Any]

            UserManager.shared.editUser(with: uid, value: value)

            UserDefaults.standard.set(name, forKey: "Name")
            UserDefaults.standard.set(gender, forKey: "Gender")
            UserDefaults.standard.set(age, forKey: "Age")
            UserDefaults.standard.set(medicine, forKey: "Medicine")
        }

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
            cell.rowView.infoLabel.font = UIFont(name: "Futura-Bold", size: 20)
            cell.rowView.infoLabel.textColor = Palette.darkblue
            cell.rowView.infoLabel.textAlignment = .center

            cell.rowView.infoTextField.delegate = self
            cell.rowView.infoTextField.returnKeyType = .done
            cell.rowView.infoTextField.textAlignment = .center

            if let name = UserDefaults.standard.value(forKey: "Name") as? String {

                cell.rowView.infoTextField.text = name

            }

            return cell

        case .gender:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileSegmentTableViewCell", for: indexPath) as! ProfileSegmentTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.infoLabel.text = component.title
            cell.rowView.infoLabel.font = UIFont(name: "Futura-Bold", size: 20)
            cell.rowView.infoLabel.textColor = Palette.darkblue
            cell.rowView.infoLabel.textAlignment = .center

            cell.rowView.infoSegmentedControl.setImage(#imageLiteral(resourceName: "male"), forSegmentAt: Gender.male.rawValue)
            cell.rowView.infoSegmentedControl.setImage(#imageLiteral(resourceName: "female"), forSegmentAt: Gender.female.rawValue)
            cell.rowView.infoSegmentedControl.tintColor = Palette.darkblue
            cell.rowView.infoSegmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName: Palette.darkblue, NSFontAttributeName: UIFont(name: "Futura-Bold", size: 20) ?? ""], for: .normal)
            cell.rowView.infoSegmentedControl.addTarget(self, action: #selector(changeGender), for: .valueChanged)

            cell.rowView.infoSegmentedControl.selectedSegmentIndex = 0

            if let gender = UserDefaults.standard.value(forKey: "Gender") as? Int {

                cell.rowView.infoSegmentedControl.selectedSegmentIndex = gender

            }

            return cell

        case .age:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTextFieldTableViewCell", for: indexPath) as! ProfileTextFieldTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.infoLabel.text = component.title
            cell.rowView.infoLabel.font = UIFont(name: "Futura-Bold", size: 20)
            cell.rowView.infoLabel.textColor = Palette.darkblue
            cell.rowView.infoLabel.textAlignment = .center

            cell.rowView.infoTextField.delegate = self
            cell.rowView.infoTextField.returnKeyType = .done

            cell.rowView.infoTextField.inputView = agePicker

            if let age = UserDefaults.standard.value(forKey: "Age") as? String {

                cell.rowView.infoTextField.text = age

            }

            return cell

        case .medicine:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileSegmentTableViewCell", for: indexPath) as! ProfileSegmentTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.infoLabel.text = component.title
            cell.rowView.infoLabel.font = UIFont(name: "Futura-Bold", size: 20)
            cell.rowView.infoLabel.textColor = Palette.darkblue
            cell.rowView.infoLabel.textAlignment = .center

            cell.rowView.infoSegmentedControl.setTitle("Yes", forSegmentAt: 0)
            cell.rowView.infoSegmentedControl.setTitle("No", forSegmentAt: 1)
            cell.rowView.infoSegmentedControl.tintColor = Palette.darkblue
            cell.rowView.infoSegmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName: Palette.darkblue, NSFontAttributeName: UIFont(name: "Futura-Bold", size: 20) ?? ""], for: .normal)
            cell.rowView.infoSegmentedControl.addTarget(self, action: #selector(changeGender), for: .valueChanged)

            cell.rowView.infoSegmentedControl.selectedSegmentIndex = 1

            if let medicine = UserDefaults.standard.value(forKey: "Medicine") as? Int {

                cell.rowView.infoSegmentedControl.selectedSegmentIndex = medicine

            }

            return cell

        case .finish:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileButtonTableViewCell", for: indexPath) as! ProfileButtonTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.profileButton.backgroundColor = Palette.darkblue
            cell.rowView.profileButton.layer.cornerRadius = cell.rowView.profileButton.frame.height / 2
            cell.rowView.profileButton.tintColor = Palette.cream
            cell.rowView.profileButton.titleLabel?.font = UIFont(name: "Futura-Bold", size: 20)

            let user = FIRAuth.auth()?.currentUser
            if user?.isAnonymous == true {

                cell.rowView.profileButton.setTitle("Sign Up", for: .normal)
                cell.rowView.profileButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)

            } else {

                cell.rowView.profileButton.setTitle("Log out", for: .normal)
                cell.rowView.profileButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)

            }

            return cell

        }

    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let component = components[indexPath.section]

        switch component {

        case .photo:

            return 300.0

        case .name, .gender, .age, .medicine, .finish:

            return 80.0

        }
    }

    func hideKeyBoard() {

        self.view.endEditing(true)

    }

    func signUp() {

        guard let signUpViewController = UIStoryboard(name: "Landing", bundle: nil).instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else { return }

        signUpViewController.isFromProfile = true

        self.present(signUpViewController, animated: true)

    }

    func logOut() {

        let alertController = UIAlertController(title: "Warning",
                                                message: "Do you want to log out?",
                                                preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "No",
                                         style: .cancel,
                                         handler: nil)

        alertController.addAction(cancelAction)

        let okAction = UIAlertAction(title: "Yes", style: .default) { _ in

            do {
                try FIRAuth.auth()?.signOut()

                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

                    UserDefaults.standard.set(false, forKey: "IsviewedWalkThrough")

                    let startViewController = UIStoryboard(name: "Landing", bundle: nil).instantiateViewController(withIdentifier: "StartViewController") as? StartViewController

                    appDelegate.window?.rootViewController = startViewController

                }

            } catch (let error) {

                let alertController = UIAlertController(title: "Warning",
                                                        message: error.localizedDescription,
                                                        preferredStyle: .alert)

                alertController.addAction(UIAlertAction(title: "OK",
                                                        style: .default,
                                                        handler: nil))

                self.present(alertController, animated: true, completion: nil)
            }

        }

        alertController.addAction(okAction)

        self.present(alertController, animated: true, completion: nil)

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

        if let ageCell = tableView.visibleCells[Component.age.rawValue] as? ProfileTextFieldTableViewCell {

            switch pickerView {

            case agePicker:

                ageCell.rowView.infoTextField.text = String(age[row])
                ageCell.rowView.infoTextField.textAlignment = .center

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
