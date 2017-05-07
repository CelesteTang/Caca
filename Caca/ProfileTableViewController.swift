//
//  ProfileTableViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/27.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit
import Firebase
import KeychainAccess

class ProfileTableViewController: UITableViewController {

//    var user = User()

    enum Component: Int {

        case photo, gender, medicine, finish

        var title: String {

            switch self {

            case .gender: return NSLocalizedString("Gender", comment: "")

            case .medicine: return NSLocalizedString("Medicine", comment: "")

            default: return ""

            }
        }
    }

    // MARK: Property

    let components: [Component] = [.photo, .gender, .medicine, .finish]

    let keychain = Keychain(service: "tw.hsinyutang.Caca-user")

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()

        self.tableView.register(ProfilePhotoTableViewCell.self, forCellReuseIdentifier: "ProfilePhotoTableViewCell")
        self.tableView.register(ProfileSegmentTableViewCell.self, forCellReuseIdentifier: "ProfileSegmentTableViewCell")
        self.tableView.register(ProfileButtonTableViewCell.self, forCellReuseIdentifier: "ProfileButtonTableViewCell")

    }

    // MARK: Set Up

    private func setUp() {

        self.tableView.backgroundColor = Palette.lightblue2
        self.tableView.allowsSelection = false
        self.tableView.separatorStyle = .none

        self.navigationItem.title = NSLocalizedString("Profile", comment: "")
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Palette.darkblue, NSFontAttributeName: UIFont(name: Constants.UIFont.futuraBold, size: 20) ?? ""]

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.isHidden = true

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        tabBarController?.tabBar.isHidden = false

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return components.count

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let component = components[section]

        switch component {

        case .photo, .gender, .medicine, .finish: return 1

        }

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let component = components[indexPath.section]

        switch component {

        case .photo:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfilePhotoTableViewCell", for: indexPath) as! ProfilePhotoTableViewCell
            // swiftlint:enable force_cast

            let gender = keychain[Constants.KeychainKey.gender]
            cell.rowView.photoImageView.image = (gender == Gender.male.title) ? #imageLiteral(resourceName: "boy") : #imageLiteral(resourceName: "girl")

            return cell

        case .gender:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileSegmentTableViewCell", for: indexPath) as! ProfileSegmentTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.infoLabel.text = component.title
            cell.rowView.infoLabel.font = UIFont(name: Constants.UIFont.futuraBold, size: 20)
            cell.rowView.infoLabel.textColor = Palette.darkblue
            cell.rowView.infoLabel.textAlignment = .center

            cell.rowView.infoSegmentedControl.setImage(#imageLiteral(resourceName: "male"), forSegmentAt: Gender.male.rawValue)
            cell.rowView.infoSegmentedControl.setImage(#imageLiteral(resourceName: "female"), forSegmentAt: Gender.female.rawValue)
            cell.rowView.infoSegmentedControl.tintColor = Palette.darkblue
            cell.rowView.infoSegmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName: Palette.darkblue, NSFontAttributeName: UIFont(name: Constants.UIFont.futuraBold, size: 20) ?? ""], for: .normal)
            cell.rowView.infoSegmentedControl.addTarget(self, action: #selector(changeGender), for: .valueChanged)

            let gender = keychain[Constants.KeychainKey.gender]

            cell.rowView.infoSegmentedControl.selectedSegmentIndex = (gender == Gender.male.title) ? Gender.male.rawValue : Gender.female.rawValue

            return cell

        case .medicine:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileSegmentTableViewCell", for: indexPath) as! ProfileSegmentTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.infoLabel.text = component.title
            cell.rowView.infoLabel.font = UIFont(name: Constants.UIFont.futuraBold, size: 20)
            cell.rowView.infoLabel.textColor = Palette.darkblue
            cell.rowView.infoLabel.textAlignment = .center

            cell.rowView.infoSegmentedControl.setTitle(NSLocalizedString("Yes", comment: ""), forSegmentAt: 0)
            cell.rowView.infoSegmentedControl.setTitle(NSLocalizedString("No", comment: ""), forSegmentAt: 1)
            cell.rowView.infoSegmentedControl.tintColor = Palette.darkblue
            cell.rowView.infoSegmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName: Palette.darkblue, NSFontAttributeName: UIFont(name: Constants.UIFont.futuraBold, size: 20) ?? ""], for: .normal)
            cell.rowView.infoSegmentedControl.addTarget(self, action: #selector(changeMedicine), for: .valueChanged)

            let medicine = keychain[Constants.KeychainKey.medicine]

            cell.rowView.infoSegmentedControl.selectedSegmentIndex = (medicine == Medicine.yes.title) ? Medicine.yes.rawValue : Medicine.no.rawValue

            return cell

        case .finish:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileButtonTableViewCell", for: indexPath) as! ProfileButtonTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.profileButton.backgroundColor = Palette.darkblue
            cell.rowView.profileButton.layer.cornerRadius = cell.rowView.profileButton.frame.height / 2
            cell.rowView.profileButton.tintColor = Palette.cream
            cell.rowView.profileButton.titleLabel?.font = UIFont(name: Constants.UIFont.futuraBold, size: 20)

            let user = FIRAuth.auth()?.currentUser
            if user?.isAnonymous == true {

                cell.rowView.profileButton.setTitle(NSLocalizedString("Sign Up", comment: ""), for: .normal)
                cell.rowView.profileButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)

            } else {

                cell.rowView.profileButton.setTitle(NSLocalizedString("Log out", comment: ""), for: .normal)
                cell.rowView.profileButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)

            }

            return cell

        }

    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let component = components[indexPath.section]

        switch component {

        case .photo: return 300.0

        case .gender, .medicine, .finish: return 80.0

        }
    }

    func signUp() {

        guard let signUpViewController = UIStoryboard(name: Constants.Storyboard.landing, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.signUp) as? SignUpViewController else { return }

        signUpViewController.isFromProfile = true

        self.present(signUpViewController, animated: true)

    }

    func logOut() {

        let alertController = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert to make user know something wrong happened"),
                                                message: NSLocalizedString("Do you want to log out?", comment: ""),
                                                preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: NSLocalizedString("No", comment: ""),
                                         style: .cancel,
                                         handler: nil)

        alertController.addAction(cancelAction)

        let okAction = UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .default) { _ in

            do {
                try FIRAuth.auth()?.signOut()

                if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

                    UserDefaults.standard.set(false, forKey: Constants.UserDefaultsKey.isViewedWalkThrough)
                    UserDefaults.standard.set(false, forKey: Constants.UserDefaultsKey.passwordAuthentication)
                    UserDefaults.standard.set(false, forKey: Constants.UserDefaultsKey.touchIDAuthentication)
                    self.keychain[Constants.KeychainKey.gender] = nil
                    self.keychain[Constants.KeychainKey.medicine] = nil
                    self.keychain[Constants.KeychainKey.password] = nil

                    let startViewController = UIStoryboard(name: Constants.Storyboard.landing, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.start) as? StartViewController

                    appDelegate.window?.rootViewController = startViewController

                }

            } catch (let error) {

                let alertController = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert to make user know something wrong happened"),
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

    func changeGender() {

        guard let photoCell = cellForComponent(.photo) as? ProfilePhotoTableViewCell else { return }
        guard let genderCell = cellForComponent(.gender) as? ProfileSegmentTableViewCell else { return }
        guard let medicineCell = cellForComponent(.medicine) as? ProfileSegmentTableViewCell else { return }

        let isMale: Bool = (genderCell.rowView.infoSegmentedControl.selectedSegmentIndex == Gender.male.rawValue)
        photoCell.rowView.photoImageView.image = isMale ? #imageLiteral(resourceName: "boy") : #imageLiteral(resourceName: "girl")

        guard let gender = Gender(rawValue: genderCell.rowView.infoSegmentedControl.selectedSegmentIndex)?.title else { return }
        guard let medicine = Medicine(rawValue: medicineCell.rowView.infoSegmentedControl.selectedSegmentIndex)?.title else { return }

        let value: [String: Any] = [Constants.FirebaseUserKey.gender: gender,
                                    Constants.FirebaseUserKey.medicine: medicine]

        UserManager.shared.editUser(value: value)

        keychain[Constants.KeychainKey.gender] = gender
    }

    func changeMedicine() {

//        guard let photoCell = cellForComponent(.photo) as? ProfilePhotoTableViewCell else { return }
        guard let genderCell = cellForComponent(.gender) as? ProfileSegmentTableViewCell else { return }
        guard let medicineCell = cellForComponent(.medicine) as? ProfileSegmentTableViewCell else { return }

        guard let gender = Gender(rawValue: genderCell.rowView.infoSegmentedControl.selectedSegmentIndex)?.title else { return }
        guard let medicine = Medicine(rawValue: medicineCell.rowView.infoSegmentedControl.selectedSegmentIndex)?.title else { return }

        let value: [String: Any] = [Constants.FirebaseUserKey.gender: gender,
                                    Constants.FirebaseUserKey.medicine: medicine]

        UserManager.shared.editUser(value: value)

        keychain[Constants.KeychainKey.medicine] = medicine
    }

    func cellForComponent(_ component: Component) -> UITableViewCell? {

        guard let section = components.index(of: component) else { return nil }

        let indexPath = IndexPath(row: 0, section: section)

        return tableView.cellForRow(at: indexPath)

    }
}
