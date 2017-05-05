//
//  FillinTableViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/18.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import ColorThiefSwift

class FillinTableViewController: UITableViewController {

    var isFromCaca = false

    var isFromRecord = false

    var isFromRecordDetail = false

    enum Component: Int {

        case photo, date, time, shape, color, amount, period, medicine, other, finish

        var title: String {

            switch self {
            case .date: return NSLocalizedString("Date", comment: "")
            case .time: return NSLocalizedString("Time", comment: "")
            case .shape: return NSLocalizedString("Shape", comment: "")
            case .color: return NSLocalizedString("Color", comment: "")
            case .amount: return NSLocalizedString("Amount", comment: "")
            case .period: return NSLocalizedString("Period", comment: "")
            case .medicine: return NSLocalizedString("Medicine", comment: "")
            case .other: return NSLocalizedString("Other", comment: "")
            default: return ""
            }
        }
    }

    // MARK: Property

    var components: [Component] = [.photo, .date, .time, .color, .shape, .amount, .other, .finish]

    let shapes: [Shape] = [.separateHard, .lumpySausage, .crackSausage, .smoothSausage, .softBlob, .mushyStool, .wateryStool]

    let colors: [Color] = [.red, .yellow, .green, .lightBrown, .darkBrown, .gray, .black]

    let datePicker = UIDatePicker()
    let timePicker = UIPickerView()
    let shapePicker = UIPickerView()
    let colorPicker = UIPickerView()
    let amountSlider = UISlider()

    var hour = [Int]()
    var min = [Int]()
    var sec = [Int]()

    var finalHour = "00"
    var finalMin = "00"
    var finalSec = "00"

    var finalCaca = Caca(cacaID: "", date: Time.dateString(), time: Time.timeString(), consumingTime: "", shape: "", color: "", amount: "", grading: false, advice: "")

    var cacas = [Caca]()

    var recievedCacaFromRecordDetail = [Caca]()

    var activityIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        if User.host.gender == Gender.female.rawValue && User.host.medicine == Medicine.yes.rawValue {

            self.components = [.photo, .date, .time, .color, .shape, .amount, .period, .medicine, .other, .finish]

        } else if User.host.gender == Gender.female.rawValue {

            self.components = [.photo, .date, .time, .color, .shape, .amount, .period, .other, .finish]

        } else if User.host.medicine == Medicine.yes.rawValue {

            self.components = [.photo, .date, .time, .color, .shape, .amount, .medicine, .other, .finish]

        }

        self.tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: "PhotoTableViewCell")
        self.tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: "InfoTableViewCell")
        self.tableView.register(FinishTableViewCell.self, forCellReuseIdentifier: "FinishTableViewCell")
        self.tableView.register(InfoSegmentTableViewCell.self, forCellReuseIdentifier: "InfoSegmentTableViewCell")

        setUp()

        DispatchQueue.global().async {

            CacaProvider.shared.getCaca { (cacas, _) in

                if let cacas = cacas {

                    self.cacas = cacas

                }
            }
        }

    }

    private func setUp() {

        self.tableView.allowsSelection = false
        self.tableView.separatorStyle = .none

        self.datePicker.datePickerMode = .dateAndTime
        self.datePicker.minuteInterval = 1
        self.datePicker.date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let fromDateTime = dateFormatter.date(from: "2015-01-01 18:08")
        self.datePicker.minimumDate = fromDateTime
        let endDateTime = dateFormatter.date(from: "2067-12-31 10:45")
        self.datePicker.maximumDate = endDateTime
        self.datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)

        self.timePicker.dataSource = self
        self.timePicker.delegate = self
        for i in 0...23 { hour.append(i) }
        for i in 0...59 { min.append(i) }
        for i in 0...59 { sec.append(i) }

        self.shapePicker.dataSource = self
        self.shapePicker.delegate = self

        self.colorPicker.dataSource = self
        self.colorPicker.delegate = self

        self.amountSlider.frame = CGRect(x: 0, y: 0, width: 300, height: 200)
        self.amountSlider.isContinuous = true
        let thumbIamge = #imageLiteral(resourceName: "caca-big").resized(targetRatio: 0.2)
        self.amountSlider.setThumbImage(thumbIamge, for: .normal)
        self.amountSlider.maximumValueImage = #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysTemplate)
        self.amountSlider.minimumValueImage = #imageLiteral(resourceName: "minus").withRenderingMode(.alwaysTemplate)
        self.amountSlider.tintColor = Palette.darkblue
        self.amountSlider.minimumValue = 0.1
        self.amountSlider.maximumValue = 0.3
        self.amountSlider.value = 0.2
        self.amountSlider.addTarget(self, action: #selector(changeThumbImageSize), for: .valueChanged)

        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        self.activityIndicator.layer.cornerRadius = 20
        self.activityIndicator.color = Palette.darkblue
        self.activityIndicator.backgroundColor = Palette.lightWhite
        let fullScreenSize = UIScreen.main.bounds.size
        self.activityIndicator.center = CGPoint(x: fullScreenSize.width * 0.5, y: fullScreenSize.height * 0.8)
        self.view.addSubview(activityIndicator)

        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

    func datePickerChanged() {

        guard let dateCell = cellForComponent(.date) as? InfoTableViewCell else { return }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"

        dateCell.rowView.infoTextField.text = formatter.string(from: datePicker.date)

    }

    func changeThumbImageSize() {

        let thumbImage: UIImage = #imageLiteral(resourceName: "caca-big")

        guard let amountCell = cellForComponent(.amount) as? InfoTableViewCell else { return }

        switch amountSlider.value {

        case 0.23...0.3:

            let newImage = thumbImage.resized(targetRatio: 0.3)
            amountCell.rowView.infoTextField.text = NSLocalizedString("Large", comment: "")
            self.amountSlider.setThumbImage(newImage, for: .normal)

        case 0.16..<0.23:

            let newImage = thumbImage.resized(targetRatio: 0.2)
            amountCell.rowView.infoTextField.text = NSLocalizedString("Normal", comment: "")
            self.amountSlider.setThumbImage(newImage, for: .normal)

        case 0.10..<0.16:

            let newImage = thumbImage.resized(targetRatio: 0.1)
            amountCell.rowView.infoTextField.text = NSLocalizedString("Small", comment: "")
            self.amountSlider.setThumbImage(newImage, for: .normal)

        default: break

        }

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return components.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let component = components[section]

        switch component {

        case .photo, .date, .time, .shape, .color, .amount, .period, .medicine, .other, .finish: return 1

        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let component = components[indexPath.section]

        switch component {

        case .photo: return 200.0

        case .date, .time, .shape, .color, .amount, .period, .medicine, .other, .finish: return 80.0

        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let photoCell = cellForComponent(.photo) as? PhotoTableViewCell else { return }

        if photoCell.rowView.cacaPhotoImageView.image != #imageLiteral(resourceName: "cacaWithCamera") {

            photoCell.rowView.cacaPhotoImageView.layer.cornerRadius = photoCell.rowView.cacaPhotoImageView.frame.width / 2
            photoCell.rowView.cacaPhotoImageView.layer.masksToBounds = true

        }

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let component = components[indexPath.section]

        switch component {

        case .photo:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell", for: indexPath) as! PhotoTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.cancelButton.addTarget(self, action: #selector(cancelFillin), for: .touchUpInside)
            cell.rowView.addPhotoButton.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)

            cell.rowView.cacaPhotoImageView.image = finalCaca.image

            if isFromRecordDetail == true {

                if let photoURL = self.recievedCacaFromRecordDetail[0].photoURL {

                    DispatchQueue.global().async {
                        if let url = URL(string: photoURL) {

                            do {
                                let data = try Data(contentsOf: url)
                                guard let image = UIImage(data: data) else { return }

                                DispatchQueue.main.async {

                                    self.finalCaca.image = image
                                    cell.rowView.cacaPhotoImageView.image = image

                                }

                            } catch {

                                print(error.localizedDescription)

                            }
                        }
                    }
                }

            }

            return cell

        case .date:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewCell", for: indexPath) as! InfoTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.infoLabel.text = component.title
            cell.rowView.infoTextField.delegate = self
            cell.rowView.infoTextField.returnKeyType = .done

            if isFromCaca == true {

                cell.rowView.infoTextField.text = "\(Time.dateString()) \(Time.timeString())"
                cell.rowView.infoTextField.isEnabled = false

            }

            if isFromRecordDetail == true {

                cell.rowView.infoTextField.text = "\(recievedCacaFromRecordDetail[0].date) \(recievedCacaFromRecordDetail[0].time)"
                self.finalCaca.date = recievedCacaFromRecordDetail[0].date
                self.finalCaca.time = recievedCacaFromRecordDetail[0].time

            }

            cell.rowView.infoTextField.inputView = datePicker

            return cell

        case .time:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewCell", for: indexPath) as! InfoTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.infoLabel.text = component.title
            cell.rowView.infoTextField.delegate = self
            cell.rowView.infoTextField.returnKeyType = .done

            if isFromCaca == true {

                cell.rowView.infoTextField.text = Time.consumingTime
                cell.rowView.infoTextField.isEnabled = false

            }

            if isFromRecordDetail == true {

                cell.rowView.infoTextField.text = recievedCacaFromRecordDetail[0].consumingTime
                self.finalCaca.consumingTime = recievedCacaFromRecordDetail[0].consumingTime

            }

            cell.rowView.infoTextField.inputView = timePicker

            return cell

        case .shape:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewCell", for: indexPath) as! InfoTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.infoLabel.text = component.title
            cell.rowView.infoTextField.delegate = self
            cell.rowView.infoTextField.returnKeyType = .done

            cell.rowView.infoTextField.inputView = shapePicker

            if isFromRecordDetail == true {

                cell.rowView.infoTextField.text = recievedCacaFromRecordDetail[0].shape
                self.finalCaca.shape = recievedCacaFromRecordDetail[0].shape

            }

            return cell

        case .color:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewCell", for: indexPath) as! InfoTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.infoLabel.text = component.title
            cell.rowView.infoTextField.delegate = self
            cell.rowView.infoTextField.returnKeyType = .done

            cell.rowView.infoTextField.inputView = colorPicker

            if isFromRecordDetail == true {

                cell.rowView.infoTextField.text = recievedCacaFromRecordDetail[0].color
                self.finalCaca.color = recievedCacaFromRecordDetail[0].color

            }

            return cell

        case .amount:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewCell", for: indexPath) as! InfoTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.infoLabel.text = component.title
            cell.rowView.infoTextField.delegate = self
            cell.rowView.infoTextField.returnKeyType = .done

            cell.rowView.infoTextField.inputView = amountSlider

            if isFromRecordDetail == true {

                cell.rowView.infoTextField.text = self.recievedCacaFromRecordDetail[0].amount
                self.finalCaca.amount = recievedCacaFromRecordDetail[0].amount

            }

            return cell

        case .period:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoSegmentTableViewCell", for: indexPath) as! InfoSegmentTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.infoLabel.text = component.title
            cell.rowView.infoLabel.font = UIFont(name: Constants.UIFont.futuraBold, size: 20)
            cell.rowView.infoLabel.textColor = Palette.darkblue
            cell.rowView.infoLabel.textAlignment = .center

            cell.rowView.infoSegmentedControl.setTitle("Yes", forSegmentAt: 0)
            cell.rowView.infoSegmentedControl.setTitle("No", forSegmentAt: 1)
            cell.rowView.infoSegmentedControl.tintColor = Palette.darkblue
            cell.rowView.infoSegmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName: Palette.darkblue, NSFontAttributeName: UIFont(name: Constants.UIFont.futuraBold, size: 20) ?? ""], for: .normal)

            cell.rowView.infoSegmentedControl.selectedSegmentIndex = 1

            if isFromRecordDetail == true {

                if let period = self.recievedCacaFromRecordDetail[0].period {

                    cell.rowView.infoSegmentedControl.selectedSegmentIndex = period
                    self.finalCaca.period = period

                }
            }

            return cell

        case .medicine:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewCell", for: indexPath) as! InfoTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.infoLabel.text = component.title
            cell.rowView.infoTextField.delegate = self
            cell.rowView.infoTextField.returnKeyType = .done

            if isFromRecordDetail == true {

                cell.rowView.infoTextField.text = recievedCacaFromRecordDetail[0].medicine
                self.finalCaca.medicine = recievedCacaFromRecordDetail[0].medicine

            }

            return cell

        case .other:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewCell", for: indexPath) as! InfoTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.infoLabel.text = component.title
            cell.rowView.infoTextField.delegate = self
            cell.rowView.infoTextField.returnKeyType = .done

            if isFromRecordDetail == true {

                cell.rowView.infoTextField.text = recievedCacaFromRecordDetail[0].otherInfo
                self.finalCaca.otherInfo = recievedCacaFromRecordDetail[0].otherInfo
            }

            return cell

        case .finish:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "FinishTableViewCell", for: indexPath) as! FinishTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.finishButton.isEnabled = true

            cell.rowView.finishButton.addTarget(self, action: #selector(didFillin), for: .touchUpInside)

            return cell

        }

    }

    func cancelFillin() {

        if isFromCaca == true {

            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

                let tabBarController = UIStoryboard(name: Constants.Storyboard.tabBar, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.tabBar) as? TabBarController

                appDelegate.window?.rootViewController = tabBarController

            }

            isFromCaca = false

        } else if isFromRecord == true {

            dismiss(animated: true, completion: nil)

            isFromRecord = false

        } else if isFromRecordDetail == true {

            dismiss(animated: true, completion: nil)

            isFromRecordDetail = false

        }

    }

    func addPhoto() {

        let alertController = UIAlertController(title: NSLocalizedString("Add a caca photo", comment: ""),
                                                message: nil,
                                                preferredStyle: .actionSheet)

        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                                         style: .cancel,
                                         handler: nil)

        alertController.addAction(cancelAction)

        let photoAction = UIAlertAction(title: NSLocalizedString("Choose from library", comment: ""), style: .default) { _ in

            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.videoQuality = .typeLow
            self.present(picker, animated: true, completion: nil)

        }

        alertController.addAction(photoAction)

        let cameraAction = UIAlertAction(title: NSLocalizedString("Take photo", comment: ""), style: .default) { _ in

            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            picker.cameraCaptureMode = .photo
            picker.cameraDevice = .rear
            picker.cameraFlashMode = .on
            picker.allowsEditing = true
            picker.videoQuality = .typeLow
            self.present(picker, animated: true, completion: nil)

        }

        alertController.addAction(cameraAction)

        self.present(alertController, animated: true, completion: nil)

    }

    func hideKeyBoard() {

        self.view.endEditing(true)

    }

    typealias NilHandler = (Bool?) -> Void

    func checkNil(completion: @escaping NilHandler) {

        guard let dateCell = cellForComponent(.date) as? InfoTableViewCell else { return }
        guard let consumingTimeCell = cellForComponent(.time) as? InfoTableViewCell else { return }
        guard let colorCell = cellForComponent(.color) as? InfoTableViewCell else { return }
        guard let shapeCell = cellForComponent(.shape) as? InfoTableViewCell else { return }
        guard let amountCell = cellForComponent(.amount) as? InfoTableViewCell else { return }

        if dateCell.rowView.infoTextField.text == "" {

            let alertController = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert to make user know something wrong happened"),
                                                    message: NSLocalizedString("Please enter your date", comment: "User must enter date"),
                                                    preferredStyle: UIAlertControllerStyle.alert)

            alertController.addAction(UIAlertAction(title: "OK",
                                                    style: UIAlertActionStyle.default,
                                                    handler: nil))

            self.present(alertController, animated: true, completion: nil)

        } else if consumingTimeCell.rowView.infoTextField.text == "" {

            let alertController = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert to make user know something wrong happened"),
                                                    message: NSLocalizedString("Please enter your time", comment: "User must enter time"),
                                                    preferredStyle: UIAlertControllerStyle.alert)

            alertController.addAction(UIAlertAction(title: "OK",
                                                    style: UIAlertActionStyle.default,
                                                    handler: nil))

            self.present(alertController, animated: true, completion: nil)

        } else if shapeCell.rowView.infoTextField.text == "" {

            let alertController = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert to make user know something wrong happened"),
                                                    message: NSLocalizedString("Please enter your shape", comment: "User must enter shape"),
                                                    preferredStyle: UIAlertControllerStyle.alert)

            alertController.addAction(UIAlertAction(title: "OK",
                                                    style: UIAlertActionStyle.default,
                                                    handler: nil))

            self.present(alertController, animated: true, completion: nil)

        } else if colorCell.rowView.infoTextField.text == "" {

            let alertController = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert to make user know something wrong happened"),
                                                    message: NSLocalizedString("Please enter your color", comment: "User must enter color"),
                                                    preferredStyle: UIAlertControllerStyle.alert)

            alertController.addAction(UIAlertAction(title: "OK",
                                                    style: UIAlertActionStyle.default,
                                                    handler: nil))

            self.present(alertController, animated: true, completion: nil)

        } else if amountCell.rowView.infoTextField.text == "" {

            let alertController = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert to make user know something wrong happened"),
                                                    message: NSLocalizedString("Please enter your amount", comment: "User must enter amount"),
                                                    preferredStyle: UIAlertControllerStyle.alert)

            alertController.addAction(UIAlertAction(title: "OK",
                                                    style: UIAlertActionStyle.default,
                                                    handler: nil))

            self.present(alertController, animated: true, completion: nil)

        } else {

            completion(true)
        }

    }

    func didFillin() {

        activityIndicator.startAnimating()

        if isFromRecordDetail == true {

            editCaca()

            isFromRecordDetail = false

        } else {

            checkNil(completion: { (success) in

                if success == true {

                    self.createCaca()

                    self.isFromCaca = false

                    self.isFromRecord = false
                }
            })
        }
    }

    func switchToRecord() {

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

            let tabBarController = UIStoryboard(name: Constants.Storyboard.tabBar, bundle: nil).instantiateViewController(withIdentifier: Constants.Identifier.tabBar) as? TabBarController

            tabBarController?.selectedIndex = TabBarItemType.record.rawValue

            appDelegate.window?.rootViewController = tabBarController

        }

    }

    func createCaca() {

        guard let finishCell = cellForComponent(.finish) as? FinishTableViewCell else { return }

        finishCell.rowView.finishButton.isEnabled = false

        guard let hostUID = FIRAuth.auth()?.currentUser?.uid else { return }
        finalCaca.cacaID = FIRDatabase.database().reference().child(Constants.FirebaseCacaKey.cacas).childByAutoId().key
        let photoID = UUID().uuidString
        let cacaState = StateManager.shared.getState(caca: finalCaca, comparedWith: self.cacas)

        finalCaca.advice = cacaState.advice
        finalCaca.grading = cacaState.grading

        // MARK : Create caca with photo

        if finalCaca.image != #imageLiteral(resourceName: "cacaWithCamera") {

            CacaProvider.shared.saveCacaPhoto(image: finalCaca.image, photoID: photoID, completion: { (cacaPhotoUrl, error) in

                if error != nil {

                    let alertController = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert to make user know something wrong happened"),
                                                            message: error?.localizedDescription,
                                                            preferredStyle: .alert)

                    alertController.addAction(UIAlertAction(title: "OK",
                                                            style: .default,
                                                            handler: nil))

                    self.present(alertController, animated: true, completion: nil)

                }

                FIRAnalytics.logEvent(withName: Constants.FirebaseAnalyticsKey.createWithPhoto, parameters: nil)

                guard let cacaPhotoUrl = cacaPhotoUrl else { return }

                self.finalCaca.photoURL = cacaPhotoUrl
                self.finalCaca.photoID = photoID

                CacaProvider.shared.saveCaca(caca: self.finalCaca, uid: hostUID)

                self.switchToRecord()

                self.activityIndicator.stopAnimating()

            })

        } else {

            // MARK : Create caca without photo

            FIRAnalytics.logEvent(withName: Constants.FirebaseAnalyticsKey.createWithoutPhoto, parameters: nil)

            CacaProvider.shared.saveCaca(caca: self.finalCaca, uid: hostUID)

            self.switchToRecord()

            self.activityIndicator.stopAnimating()

        }

    }

    func editCaca() {

        guard let finishCell = cellForComponent(.finish) as? FinishTableViewCell else { return }

        finishCell.rowView.finishButton.isEnabled = false

        guard let hostUID = FIRAuth.auth()?.currentUser?.uid else { return }

        finalCaca.cacaID = recievedCacaFromRecordDetail[0].cacaID
        let cacaState = StateManager.shared.getState(caca: finalCaca, comparedWith: self.cacas)

        finalCaca.advice = cacaState.advice
        finalCaca.grading = cacaState.grading

        // MARK : Edit caca with new photo (had old photo)

        if let photoID = recievedCacaFromRecordDetail[0].photoID, finalCaca.image != #imageLiteral(resourceName: "cacaWithCamera") {

            CacaProvider.shared.editCacaPhoto(image: finalCaca.image, photoID: photoID, completion: { (cacaPhotoUrl, storageError, deleteError) in

                if storageError != nil {

                    let alertController = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert to make user know something wrong happened"),
                                                            message: storageError?.localizedDescription,
                                                            preferredStyle: .alert)

                    alertController.addAction(UIAlertAction(title: "OK",
                                                            style: .default,
                                                            handler: nil))

                    self.present(alertController, animated: true, completion: nil)

                }

                if deleteError != nil {

                    let alertController = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert to make user know something wrong happened"),
                                                            message: deleteError?.localizedDescription,
                                                            preferredStyle: .alert)

                    alertController.addAction(UIAlertAction(title: "OK",
                                                            style: .default,
                                                            handler: nil))

                    self.present(alertController, animated: true, completion: nil)

                }

                FIRAnalytics.logEvent(withName: Constants.FirebaseAnalyticsKey.editWithPhoto, parameters: nil)

                guard let cacaPhotoUrl = cacaPhotoUrl else { return }

                self.finalCaca.photoURL = cacaPhotoUrl
                self.finalCaca.photoID = photoID

                CacaProvider.shared.saveCaca(caca: self.finalCaca, uid: hostUID)

                self.switchToRecord()

                self.activityIndicator.stopAnimating()
            })

        } else if finalCaca.image != #imageLiteral(resourceName: "cacaWithCamera") && recievedCacaFromRecordDetail[0].photoID == nil {

            // MARK : Edit caca with new photo (no old photo)

            let newPhotoID = UUID().uuidString

            CacaProvider.shared.saveCacaPhoto(image: finalCaca.image, photoID: newPhotoID, completion: { (cacaPhotoUrl, error) in

                if error != nil {

                    let alertController = UIAlertController(title: NSLocalizedString("Warning", comment: "Alert to make user know something wrong happened"),
                                                            message: error?.localizedDescription,
                                                            preferredStyle: .alert)

                    alertController.addAction(UIAlertAction(title: "OK",
                                                            style: .default,
                                                            handler: nil))

                    self.present(alertController, animated: true, completion: nil)

                }

                FIRAnalytics.logEvent(withName: Constants.FirebaseAnalyticsKey.editWithPhoto, parameters: nil)

                guard let cacaPhotoUrl = cacaPhotoUrl else { return }

                self.finalCaca.photoURL = cacaPhotoUrl
                self.finalCaca.photoID = newPhotoID

                CacaProvider.shared.saveCaca(caca: self.finalCaca, uid: hostUID)

                self.switchToRecord()

                self.activityIndicator.stopAnimating()

            })

        } else if finalCaca.image == #imageLiteral(resourceName: "cacaWithCamera") {

            // MARK : Edit caca without new photo (no old photo)

            FIRAnalytics.logEvent(withName: Constants.FirebaseAnalyticsKey.editWithoutPhoto, parameters: nil)

            CacaProvider.shared.saveCaca(caca: self.finalCaca, uid: hostUID)

            self.switchToRecord()

            self.activityIndicator.stopAnimating()

        }
    }
}

extension FillinTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        guard let photoCell = cellForComponent(.photo) as? PhotoTableViewCell else { return }
        guard let colorCell = cellForComponent(.color) as? InfoTableViewCell else { return }

        guard let editedCacaImage = info[UIImagePickerControllerEditedImage] as? UIImage else { return }

        photoCell.rowView.cacaPhotoImageView.image = editedCacaImage

        finalCaca.image = editedCacaImage

        guard let dominantColor = ColorThief.getColor(from: editedCacaImage) else { return }

        dismiss(animated: true) {

            let alertController = UIAlertController(title: NSLocalizedString("Note", comment: "Note to let user know the detection color"),
                                                    message: NSLocalizedString("The color of your caca is closed to ", comment: "") + "\(dominantColor.closedColor())",
                preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in

                colorCell.rowView.infoTextField.text = dominantColor.closedColor()
                self.finalCaca.color = dominantColor.closedColor()

            })

            alertController.addAction(okAction)

            self.present(alertController, animated: true, completion: nil)

        }
    }
}

extension FillinTableViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        self.view.endEditing(true)

        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {

        self.view.endEditing(true)

        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {

        if let dateCell = cellForComponent(.date) as? InfoTableViewCell,
            let date = dateCell.rowView.infoTextField.text {

            if date != "" {
            
                finalCaca.date = date.substring(to: 10)
                finalCaca.time = date.substring(from: 11)
                
            }

        }

        if let consumingTimeCell = cellForComponent(.time) as? InfoTableViewCell,
            let consumingTime = consumingTimeCell.rowView.infoTextField.text {

            finalCaca.consumingTime = consumingTime

        }

        if let colorCell = cellForComponent(.color) as? InfoTableViewCell,
            let color = colorCell.rowView.infoTextField.text {

            finalCaca.color = color

        }

        if let shapeCell = cellForComponent(.shape) as? InfoTableViewCell,
           let shape = shapeCell.rowView.infoTextField.text {

            finalCaca.shape = shape

        }

        if let amountCell = cellForComponent(.amount) as? InfoTableViewCell,
           let amount = amountCell.rowView.infoTextField.text {

            finalCaca.amount = amount

        }

        if let medicineCell = cellForComponent(.medicine) as? InfoTableViewCell {

            finalCaca.medicine = medicineCell.rowView.infoTextField.text

        }

        if let otherCell = cellForComponent(.other) as? InfoTableViewCell {

            finalCaca.otherInfo = otherCell.rowView.infoTextField.text

        }

    }

    func cellForComponent(_ component: Component) -> UITableViewCell? {

        guard let section = components.index(of: component) else { return nil }

        let indexPath = IndexPath(row: 0, section: section)

        return tableView.cellForRow(at: indexPath)

    }

}

extension FillinTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {

        switch pickerView {

        case timePicker: return 3

        default: return 1

        }

    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        switch pickerView {

        case timePicker:

            switch component {

            case 0: return hour.count

            case 1: return min.count

            case 2: return sec.count

            default: return 0

            }

        case shapePicker: return shapes.count

        case colorPicker: return colors.count

        default: return 0

        }

    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        guard let consumingTimeCell = cellForComponent(.time) as? InfoTableViewCell else { return }
        guard let shapeCell = cellForComponent(.shape) as? InfoTableViewCell else { return }
        guard let colorCell = cellForComponent(.color) as? InfoTableViewCell else { return }

        switch pickerView {

        case timePicker:

            switch component {
            case 0: finalHour = String(format: "%02i", hour[row])
            case 1: finalMin = String(format: "%02i", min[row])
            case 2: finalSec = String(format: "%02i", sec[row])
            default: break
            }

            consumingTimeCell.rowView.infoTextField.text = "\(finalHour):\(finalMin):\(finalSec)"

        case shapePicker:

            shapeCell.rowView.infoTextField.text = shapes[row].title

        case colorPicker:

            colorCell.rowView.infoTextField.text = colors[row].title

        default: break

        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        switch pickerView {

        case timePicker:

            let pickerLabel = UILabel()

            switch component {

            case 0: pickerLabel.text = String(format: "%02i", hour[row])

            case 1: pickerLabel.text = String(format: "%02i", min[row])

            case 2: pickerLabel.text = String(format: "%02i", sec[row])

            default: break

            }

            pickerLabel.font = UIFont(name: Constants.UIFont.futuraBold, size: 20)

            pickerLabel.textAlignment = NSTextAlignment.center

            return pickerLabel

        case shapePicker:

            let rendererShape = shapes[row]

            return ShapeSpinnerItemRenderer(frame: CGRect(), shape : rendererShape)

        case colorPicker:

            let rendererColor = colors[row]

            return ColorSpinnerItemRenderer(frame: CGRect(), color : rendererColor)

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

extension String {

    func index(from: Int) -> Index {

        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {

        let fromIndex = index(from: from)
        return substring(from: fromIndex)

    }

    func substring(to: Int) -> String {

        let toIndex = index(from: to)
        return substring(to: toIndex)

    }

    func substring(with range: Range<Int>) -> String {
        
        let startIndex = index(from: range.lowerBound)
        let endIndex = index(from: range.upperBound)
        return substring(with: startIndex..<endIndex)
        
    }

}

extension UIImage {

    func resized(targetRatio: CGFloat) -> UIImage {

        let size = self.size

        let newSize = CGSize(width: size.width * targetRatio, height: size.height * targetRatio)

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)

        self.draw(in: rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return newImage!
    }
}

extension MMCQ.Color {

    func closedColor() -> String {

        let r = Int(self.r)
        let g = Int(self.g)
        let b = Int(self.b)

        let toRed = ((146 - r) * (146 - r)) + ((18 - g) * (18 - g)) + ((36 - b) * (36 - b))
        let toYellow = ((255 - r) * (255 - r)) + ((205 - g) * (205 - g)) + ((56 - b) * (56 - b))
        let toGreen = ((83 - r) * (83 - r)) + ((90 - g) * (90 - g)) + ((59 - b) * (59 - b))
        let toLightBrown = ((168 - r) * (168 - r)) + ((116 - g) * (116 - g)) + ((66 - b) * (66 - b))
        let toDarkBrown = ((71 - r) * (71 - r)) + ((40 - g) * (40 - g)) + ((12 - b) * (12 - b))
        let toGray = ((192 - r) * (192 - r)) + ((192 - g) * (192 - g)) + ((192 - b) * (192 - b))
        let toBlack = ((0 - r) * (0 - r)) + ((0 - g) * (0 - g)) + ((0 - b) * (0 - b))

        let UIntArray = [ toRed, toYellow, toGreen, toLightBrown, toDarkBrown, toGray, toBlack ]
        if let closedUInt = (UIntArray.sorted { $0 < $1 }.first) {

            switch closedUInt {
            case toRed: return Color.red.title
            case toYellow: return Color.yellow.title
            case toGreen: return Color.green.title
            case toLightBrown: return Color.lightBrown.title
            case toDarkBrown: return Color.darkBrown.title
            case toGray: return Color.gray.title
            case toBlack: return Color.black.title
            default: return ""
            }

        } else {

            return ""

        }
    }
}
