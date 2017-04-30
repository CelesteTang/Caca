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
            case .date: return "Date"
            case .time: return "Time"
            case .shape: return "Shape"
            case .color: return "Color"
            case .amount: return "Amount"
            case .period: return "Period"
            case .medicine: return "Medicine"
            case .other: return "Other"
            default: return ""
            }
        }
    }

    // MARK: Property

    var components: [Component] = [.photo, .date, .time, .shape, .color, .amount, .other, .finish]

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

    var ispassed = false

    var isCorrect = false

    var finalCaca = FinalCaca(date: "", time: "", consumingTime: "", shape: "", color: "", amount: "", otherInfo: "", image: #imageLiteral(resourceName: "caca-big"), period: 1, medicine: "")

    var cacas = [Caca]()

    var advice = String()

    var shapeAdvice = String()

    var colorAdvice = String()

    var frequencyAdvice = String()

    var recievedCacaFromRecordDetail = [Caca]()

    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.value(forKey: "Gender") as? Int == Gender.female.rawValue && UserDefaults.standard.value(forKey: "Medicine") as? Int == 0 {

            components = [.photo, .date, .time, .shape, .color, .amount, .period, .medicine, .other, .finish]

        } else if UserDefaults.standard.value(forKey: "Gender") as? Int == Gender.female.rawValue {

            components = [.photo, .date, .time, .shape, .color, .amount, .period, .other, .finish]

        } else if UserDefaults.standard.value(forKey: "Medicine") as? Int == 0 {

            components = [.photo, .date, .time, .shape, .color, .amount, .medicine, .other, .finish]

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

        ispassed = false

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
        self.datePicker.locale = Locale(identifier: "zh_TW")
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
        let thumbIamge = self.resizeImage(image: #imageLiteral(resourceName: "caca-big"), targetRatio: 0.2)
        self.amountSlider.setThumbImage(thumbIamge, for: .normal)
        self.amountSlider.maximumValueImage = #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysTemplate)
        self.amountSlider.minimumValueImage = #imageLiteral(resourceName: "minus").withRenderingMode(.alwaysTemplate)
        self.amountSlider.tintColor = Palette.darkblue
        self.amountSlider.minimumValue = 0.1
        self.amountSlider.maximumValue = 0.3
        self.amountSlider.value = 0.2
        self.amountSlider.addTarget(self, action: #selector(changeThumbImageSize), for: .valueChanged)

        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }

    func datePickerChanged() {

        if let dateSection = components.index(of: Component.date) {

            let indexPath = IndexPath(row: 0, section: dateSection)

            let dateCell = tableView.cellForRow(at: indexPath) as? InfoTableViewCell

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"

            dateCell?.rowView.infoTextField.text = formatter.string(from: datePicker.date)

        }
    }

    func changeThumbImageSize() {

        let thumbImage: UIImage = #imageLiteral(resourceName: "caca-big")

        if let amountSection = components.index(of: Component.amount) {

            let indexPath = IndexPath(row: 0, section: amountSection)

            let amountCell = tableView.cellForRow(at: indexPath) as? InfoTableViewCell

            switch amountSlider.value {

            case 0.23...0.3:

                let newImage = self.resizeImage(image: thumbImage, targetRatio: 0.3)
                amountCell?.rowView.infoTextField.text = "Large"
                self.amountSlider.setThumbImage(newImage, for: .normal)

            case 0.16..<0.23:

                let newImage = self.resizeImage(image: thumbImage, targetRatio: 0.2)
                amountCell?.rowView.infoTextField.text = "Normal"
                self.amountSlider.setThumbImage(newImage, for: .normal)

            case 0.10..<0.16:

                let newImage = self.resizeImage(image: thumbImage, targetRatio: 0.1)
                amountCell?.rowView.infoTextField.text = "Small"
                self.amountSlider.setThumbImage(newImage, for: .normal)

            default: break

            }
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

        guard let photoSection = components.index(of: Component.photo) else { return }

        let indexPath = IndexPath(row: 0, section: photoSection)

        if let photoCell = tableView.cellForRow(at: indexPath) as? PhotoTableViewCell,
           photoCell.rowView.cacaPhotoImageView.image != #imageLiteral(resourceName: "caca-big") {

            photoCell.rowView.cacaPhotoImageView.layer.cornerRadius = photoCell.rowView.cacaPhotoImageView.frame.width / 2
            photoCell.rowView.cacaPhotoImageView.layer.masksToBounds = true

            photoCell.rowView.detectionColorImageView.layer.cornerRadius = photoCell.rowView.detectionColorImageView.frame.width / 2
            photoCell.rowView.detectionColorImageView.layer.masksToBounds = true
        }

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let component = components[indexPath.section]

        switch component {

        case .photo:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell", for: indexPath) as! PhotoTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.cancelButton.setTitle("", for: .normal)
            let buttonImage = #imageLiteral(resourceName: "cancel").withRenderingMode(.alwaysTemplate)
            cell.rowView.cancelButton.setImage(buttonImage, for: .normal)
            cell.rowView.cancelButton.tintColor = Palette.darkblue

            cell.rowView.addPhotoButton.setTitle("", for: .normal)
            let photoButtonImage = #imageLiteral(resourceName: "camera").withRenderingMode(.alwaysTemplate)
            cell.rowView.addPhotoButton.setImage(photoButtonImage, for: .normal)
            cell.rowView.addPhotoButton.tintColor = Palette.darkblue

            cell.rowView.cancelButton.addTarget(self, action: #selector(cancelFillin), for: .touchUpInside)
            cell.rowView.addPhotoButton.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)

            cell.rowView.cacaPhotoImageView.image = finalCaca.image
            cell.rowView.detectionColorImageView.backgroundColor = UIColor.clear

            if isFromRecordDetail == true {

                if self.recievedCacaFromRecordDetail[0].photo != "" {

                    DispatchQueue.global().async {
                        if let url = URL(string: self.recievedCacaFromRecordDetail[0].photo) {

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

            }

            return cell

        case .period:

            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoSegmentTableViewCell", for: indexPath) as! InfoSegmentTableViewCell
            // swiftlint:enable force_cast

            cell.rowView.infoLabel.text = component.title
            cell.rowView.infoLabel.font = UIFont(name: "Futura-Bold", size: 20)
            cell.rowView.infoLabel.textColor = Palette.darkblue
            cell.rowView.infoLabel.textAlignment = .center

            cell.rowView.infoSegmentedControl.setTitle("Yes", forSegmentAt: 0)
            cell.rowView.infoSegmentedControl.setTitle("No", forSegmentAt: 1)
            cell.rowView.infoSegmentedControl.tintColor = Palette.darkblue
            cell.rowView.infoSegmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName: Palette.darkblue, NSFontAttributeName: UIFont(name: "Futura-Bold", size: 20) ?? ""], for: .normal)

            cell.rowView.infoSegmentedControl.selectedSegmentIndex = 1

            if isFromRecordDetail == true {

                if let period = self.recievedCacaFromRecordDetail[0].period {

                cell.rowView.infoSegmentedControl.selectedSegmentIndex = period

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

                let tabBarController = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? TabBarController

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

        let alertController = UIAlertController(title: "Add a caca photo",
                                                message: nil,
                                                preferredStyle: .actionSheet)

        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)

        alertController.addAction(cancelAction)

        let photoAction = UIAlertAction(title: "Choose from library", style: .default) { _ in

            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.videoQuality = .typeLow
            self.present(picker, animated: true, completion: nil)

        }

        alertController.addAction(photoAction)

        let cameraAction = UIAlertAction(title: "Take photo", style: .default) { _ in

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

    func checkNil() {

        guard let dateSection = components.index(of: Component.date),
              let timeSection = components.index(of: Component.time),
              let shapeSection = components.index(of: Component.shape),
              let colorSection = components.index(of: Component.color),
              let amountSection = components.index(of: Component.amount) else { return }

        let dateIndexPath = IndexPath(row: 0, section: dateSection)
        let timeIndexPath = IndexPath(row: 0, section: timeSection)
        let shapeIndexPath = IndexPath(row: 0, section: shapeSection)
        let colorIndexPath = IndexPath(row: 0, section: colorSection)
        let amountIndexPath = IndexPath(row: 0, section: amountSection)

        let dateCell = tableView.cellForRow(at: dateIndexPath) as? InfoTableViewCell
        let timeCell = tableView.cellForRow(at: timeIndexPath) as? InfoTableViewCell
        let shapeCell = tableView.cellForRow(at: shapeIndexPath) as? InfoTableViewCell
        let colorCell = tableView.cellForRow(at: colorIndexPath) as? InfoTableViewCell
        let amountCell = tableView.cellForRow(at: amountIndexPath) as? InfoTableViewCell

        if dateCell?.rowView.infoTextField.text == "" {

            let alertController = UIAlertController(title: "Warning",
                                                    message: "Please enter the date",
                                                    preferredStyle: UIAlertControllerStyle.alert)

            alertController.addAction(UIAlertAction(title: "OK",
                                                    style: UIAlertActionStyle.default,
                                                    handler: nil))

            self.present(alertController, animated: true, completion: nil)

        } else if timeCell?.rowView.infoTextField.text == "" {

            let alertController = UIAlertController(title: "Warning",
                                                    message: "Please enter the time",
                                                    preferredStyle: UIAlertControllerStyle.alert)

            alertController.addAction(UIAlertAction(title: "OK",
                                                    style: UIAlertActionStyle.default,
                                                    handler: nil))

            self.present(alertController, animated: true, completion: nil)

        } else if shapeCell?.rowView.infoTextField.text == "" {

            let alertController = UIAlertController(title: "Warning",
                                                    message: "Please enter the shape",
                                                    preferredStyle: UIAlertControllerStyle.alert)

            alertController.addAction(UIAlertAction(title: "OK",
                                                    style: UIAlertActionStyle.default,
                                                    handler: nil))

            self.present(alertController, animated: true, completion: nil)

        } else if colorCell?.rowView.infoTextField.text == "" {

            let alertController = UIAlertController(title: "Warning",
                                                    message: "Please enter the color",
                                                    preferredStyle: UIAlertControllerStyle.alert)

            alertController.addAction(UIAlertAction(title: "OK",
                                                    style: UIAlertActionStyle.default,
                                                    handler: nil))

            self.present(alertController, animated: true, completion: nil)

        } else if amountCell?.rowView.infoTextField.text == "" {

            let alertController = UIAlertController(title: "Warning",
                                                    message: "Please enter the amount",
                                                    preferredStyle: UIAlertControllerStyle.alert)

            alertController.addAction(UIAlertAction(title: "OK",
                                                    style: UIAlertActionStyle.default,
                                                    handler: nil))

            self.present(alertController, animated: true, completion: nil)

        } else {

            isCorrect = true

        }

    }

    func didFillin() {

        if isFromRecordDetail == true {

            editCaca()

            isFromRecordDetail = false

        } else {

            checkNil()

            if isCorrect == true {

                createCaca()

                isFromCaca = false

                isFromRecord = false

            }

        }

    }

    func getAdvice() -> String {

        guard let shapeSection = components.index(of: Component.shape),
              let colorSection = components.index(of: Component.color) else { return "" }

        let shapeIndexPath = IndexPath(row: 0, section: shapeSection)
        let colorIndexPath = IndexPath(row: 0, section: colorSection)

        guard let shapeCell = tableView.cellForRow(at: shapeIndexPath) as? InfoTableViewCell,
              let colorCell = tableView.cellForRow(at: colorIndexPath) as? InfoTableViewCell,
              let shape = shapeCell.rowView.infoTextField.text,
              let color = colorCell.rowView.infoTextField.text else { return "" }

        // MARK: Pass or Fail

        if (color == Color.lightBrown.title || color == Color.darkBrown.title) && (shape == Shape.crackSausage.title || shape == Shape.smoothSausage.title) {

            ispassed = true

            self.advice = "Good caca! Please keep it up!"

        } else {

            self.advice = "Warning! Your caca may not be healthy! "

            // MARK: Shape

            switch shape {

            case Shape.separateHard.title, Shape.lumpySausage.title:

                self.shapeAdvice = "You are constipated, and "

            case Shape.crackSausage.title, Shape.smoothSausage.title:

                self.shapeAdvice = "The shape of your caca is good, but "

            case Shape.softBlob.title, Shape.mushyStool.title, Shape.wateryStool.title:

                self.shapeAdvice = "You have diarrhea, and "

            default: break

            }

            // MARK: Color

            switch color {

            case Color.red.title:

                self.colorAdvice = "the color of your caca is red. "

            case Color.yellow.title:

                self.colorAdvice = "the color of your caca is yellow. "

            case Color.green.title:

                self.colorAdvice = "the color of your caca is green. "

            case Color.lightBrown.title, Color.darkBrown.title:

                self.colorAdvice = "the color of your caca is good! "

            case Color.gray.title:

                self.colorAdvice = "the color of your caca is gray. "

            case Color.black.title:

                self.colorAdvice = "the color of your caca is black. "

            default: break

            }

            // MARK: Continuous Fail

            if cacas.count == 1 {

                if cacas[cacas.count - 1].grading == false && ispassed == false {

                    self.frequencyAdvice = "If you have the same symptom tomorrow, you should go to see a doctor."

                }

            } else if cacas.count > 1 {

                if cacas[cacas.count - 2].grading == false && cacas[cacas.count - 1].grading == false && ispassed == false {

                    self.frequencyAdvice = "You should go to see a doctor NOW!"

                } else if cacas[cacas.count - 1].grading == false && ispassed == false {

                    self.frequencyAdvice = "If you have the same symptom tomorrow, you should go to see a doctor."

                }

            }
        }

        let overallAdvice = self.advice + self.shapeAdvice + self.colorAdvice + self.frequencyAdvice

        return overallAdvice
    }

    func switchToRecord() {

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {

            let tabBarController = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? TabBarController

            tabBarController?.selectedIndex = TabBarItemType.record.rawValue

            appDelegate.window?.rootViewController = tabBarController

        }

    }

    func createCaca() {

        guard let finishSection = components.index(of: Component.finish) else { return }

        let finishIndexPath = IndexPath(row: 0, section: finishSection)

        guard let finishCell = tableView.cellForRow(at: finishIndexPath) as? FinishTableViewCell else { return }

        finishCell.rowView.finishButton.isEnabled = false

        guard let hostUID = FIRAuth.auth()?.currentUser?.uid else { return }

        let cacaID = FIRDatabase.database().reference().child("cacas").childByAutoId().key
        let photoID = UUID().uuidString
        let overallAdvice = getAdvice()

        // MARK : Create caca with photo

        if finalCaca.image != #imageLiteral(resourceName: "caca-big") {

            CacaProvider.shared.saveCacaPhoto(image: finalCaca.image, photoID: photoID, completion: { (cacaPhotoUrl, error) in

                if error != nil {

                    let alertController = UIAlertController(title: "Warning",
                                                            message: error?.localizedDescription,
                                                            preferredStyle: .alert)

                    alertController.addAction(UIAlertAction(title: "OK",
                                                            style: .default,
                                                            handler: nil))

                    self.present(alertController, animated: true, completion: nil)

                }

                FIRAnalytics.logEvent(withName: "CreateWithPhoto", parameters: nil)

                guard let cacaPhotoUrl = cacaPhotoUrl else { return }

                let value = ["host": hostUID,
                             "cacaID": cacaID,
                             "photo": cacaPhotoUrl,
                             "photoID": photoID,
                             "date": self.finalCaca.date,
                             "time": self.finalCaca.time,
                             "consumingTime": self.finalCaca.consumingTime,
                             "shape": self.finalCaca.shape,
                             "color": self.finalCaca.color,
                             "amount": self.finalCaca.amount,
                             "other": self.finalCaca.otherInfo ?? "",
                             "grading": self.ispassed,
                             "advice": overallAdvice,
                             "period": self.finalCaca.period ?? "",
                             "medicine": self.finalCaca.medicine ?? ""] as [String : Any]

                CacaProvider.shared.saveCaca(cacaID: cacaID, value: value)

                self.switchToRecord()

            })

        } else {

            // MARK : Create caca without photo

            let value = ["host": hostUID,
                         "cacaID": cacaID,
                         "photo": "",
                         "photoID": "",
                         "date": self.finalCaca.date,
                         "time": self.finalCaca.time,
                         "consumingTime": self.finalCaca.consumingTime,
                         "shape": self.finalCaca.shape,
                         "color": self.finalCaca.color,
                         "amount": self.finalCaca.amount,
                         "other": self.finalCaca.otherInfo ?? "",
                         "grading": self.ispassed,
                         "advice": overallAdvice,
                         "period": self.finalCaca.period ?? "",
                         "medicine": self.finalCaca.medicine ?? ""] as [String : Any]

            CacaProvider.shared.saveCaca(cacaID: cacaID, value: value)

            self.switchToRecord()

        }

    }

    func editCaca() {

        guard let finishSection = components.index(of: Component.finish) else { return }

        let finishIndexPath = IndexPath(row: 0, section: finishSection)

        guard let finishCell = tableView.cellForRow(at: finishIndexPath) as? FinishTableViewCell else { return }

        finishCell.rowView.finishButton.isEnabled = false

        guard let hostUID = FIRAuth.auth()?.currentUser?.uid else { return }

        let cacaID = recievedCacaFromRecordDetail[0].cacaID
        let photoID = recievedCacaFromRecordDetail[0].photoID
        let overallAdvice = getAdvice()

        // MARK : Edit caca with new photo (had old photo)

        if finalCaca.image != #imageLiteral(resourceName: "caca-big") && recievedCacaFromRecordDetail[0].photoID != "" {

            CacaProvider.shared.editCacaPhoto(image: finalCaca.image, photoID: photoID, completion: { (cacaPhotoUrl, storageError, deleteError) in

                if storageError != nil {

                    let alertController = UIAlertController(title: "Warning",
                                                            message: storageError?.localizedDescription,
                                                            preferredStyle: .alert)

                    alertController.addAction(UIAlertAction(title: "OK",
                                                            style: .default,
                                                            handler: nil))

                    self.present(alertController, animated: true, completion: nil)

                }

                if deleteError != nil {

                    let alertController = UIAlertController(title: "Warning",
                                                            message: deleteError?.localizedDescription,
                                                            preferredStyle: .alert)

                    alertController.addAction(UIAlertAction(title: "OK",
                                                            style: .default,
                                                            handler: nil))

                    self.present(alertController, animated: true, completion: nil)

                }

                FIRAnalytics.logEvent(withName: "EditWithPhoto", parameters: nil)

                guard let cacaPhotoUrl = cacaPhotoUrl else { return }
                let value = ["host": hostUID,
                             "cacaID": cacaID,
                             "photo": cacaPhotoUrl,
                             "photoID": photoID,
                             "date": self.finalCaca.date,
                             "time": self.finalCaca.time,
                             "consumingTime": self.finalCaca.consumingTime,
                             "shape": self.finalCaca.shape,
                             "color": self.finalCaca.color,
                             "amount": self.finalCaca.amount,
                             "other": self.finalCaca.otherInfo ?? "",
                             "grading": self.ispassed,
                             "advice": overallAdvice,
                             "period": self.finalCaca.period ?? "",
                             "medicine": self.finalCaca.medicine ?? ""] as [String : Any]

                CacaProvider.shared.editCaca(cacaID: cacaID, value: value)

                self.switchToRecord()

            })

        } else if finalCaca.image != #imageLiteral(resourceName: "caca-big") && recievedCacaFromRecordDetail[0].photoID == "" {

            // MARK : Edit caca with new photo (no old photo)

            CacaProvider.shared.saveCacaPhoto(image: finalCaca.image, photoID: photoID, completion: { (cacaPhotoUrl, error) in

                if error != nil {

                    let alertController = UIAlertController(title: "Warning",
                                                            message: error?.localizedDescription,
                                                            preferredStyle: .alert)

                    alertController.addAction(UIAlertAction(title: "OK",
                                                            style: .default,
                                                            handler: nil))

                    self.present(alertController, animated: true, completion: nil)

                }

                FIRAnalytics.logEvent(withName: "EditWithPhoto", parameters: nil)

                guard let cacaPhotoUrl = cacaPhotoUrl else { return }
                let value = ["host": hostUID,
                             "cacaID": cacaID,
                             "photo": cacaPhotoUrl,
                             "photoID": photoID,
                             "date": self.finalCaca.date,
                             "time": self.finalCaca.time,
                             "consumingTime": self.finalCaca.consumingTime,
                             "shape": self.finalCaca.shape,
                             "color": self.finalCaca.color,
                             "amount": self.finalCaca.amount,
                             "other": self.finalCaca.otherInfo ?? "",
                             "grading": self.ispassed,
                             "advice": overallAdvice,
                             "period": self.finalCaca.period ?? "",
                             "medicine": self.finalCaca.medicine ?? ""] as [String : Any]

                CacaProvider.shared.editCaca(cacaID: cacaID, value: value)

                self.switchToRecord()

            })

        } else if finalCaca.image == #imageLiteral(resourceName: "caca-big") {

            // MARK : Edit caca without new photo (no old photo)

            let value = ["host": hostUID,
                         "cacaID": cacaID,
                         "photo": "",
                         "photoID": "",
                         "date": self.finalCaca.date,
                         "time": self.finalCaca.time,
                         "consumingTime": self.finalCaca.consumingTime,
                         "shape": self.finalCaca.shape,
                         "color": self.finalCaca.color,
                         "amount": self.finalCaca.amount ,
                         "other": self.finalCaca.otherInfo ?? "",
                         "grading": self.ispassed,
                         "advice": overallAdvice,
                         "period": self.finalCaca.period ?? "",
                         "medicine": self.finalCaca.medicine ?? ""] as [String : Any]

            CacaProvider.shared.editCaca(cacaID: cacaID, value: value)

            self.switchToRecord()

        }
    }
}

extension FillinTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        guard let photoSection = components.index(of: Component.photo),
              let colorSection = components.index(of: Component.color) else { return }

        let photoIndexPath = IndexPath(row: 0, section: photoSection)
        let colorIndexPath = IndexPath(row: 0, section: colorSection)

        guard let photoCell = tableView.cellForRow(at: photoIndexPath) as? PhotoTableViewCell,
              let colorCell = tableView.cellForRow(at: colorIndexPath) as? InfoTableViewCell else { return }

        guard let editedCacaImage = info[UIImagePickerControllerEditedImage] as? UIImage else { return }

        photoCell.rowView.cacaPhotoImageView.image = editedCacaImage

        finalCaca.image = editedCacaImage

        guard let dominantColor = ColorThief.getColor(from: editedCacaImage) else { return }

        dismiss(animated: true) {

            let alertController = UIAlertController(title: "Note",
                                                    message: "The color of your caca is closed to \(self.getClosedColor(of: dominantColor))",
                preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in

                colorCell.rowView.infoTextField.text = "\(self.getClosedColor(of: dominantColor))"

            })

            alertController.addAction(okAction)

            self.present(alertController, animated: true, completion: nil)

        }
    }

    func getClosedColor(of dominantColor: MMCQ.Color) -> String {

        let r = Int(dominantColor.r)
        let g = Int(dominantColor.g)
        let b = Int(dominantColor.b)

        let toRed = ((146 - r) * (146 - r)) + ((18 - g) * (18 - g)) + ((36 - b) * (36 - b))
        let toYellow = ((255 - r) * (255 - r)) + ((205 - g) * (205 - g)) + ((56 - b) * (56 - b))
        let toGreen = ((83 - r) * (83 - r)) + ((90 - g) * (90 - g)) + ((59 - b) * (59 - b))
        let toLightBrown = ((168 - r) * (168 - r)) + ((116 - g) * (116 - g)) + ((66 - b) * (66 - b))
        let toDarkBrown = ((71 - r) * (71 - r)) + ((40 - g) * (40 - g)) + ((12 - b) * (12 - b))
        let toGray = ((192 - r) * (192 - r)) + ((192 - g) * (192 - g)) + ((192 - b) * (192 - b))
        let toBlack = ((0 - r) * (0 - r)) + ((0 - g) * (0 - g)) + ((0 - b) * (0 - b))

        let UInt8Array = [ toRed, toYellow, toGreen, toLightBrown, toDarkBrown, toGray, toBlack ]
        let closedUInt8 = UInt8Array.sorted { $0 < $1 }.first

        if closedUInt8 == toRed {

            return Color.red.title

        } else if closedUInt8 == toYellow {

            return Color.yellow.title

        } else if closedUInt8 == toGreen {

            return Color.green.title

        } else if closedUInt8 == toLightBrown {

            return Color.lightBrown.title

        } else if closedUInt8 == toDarkBrown {

            return Color.darkBrown.title

        } else if closedUInt8 == toGray {

            return Color.gray.title

        } else if closedUInt8 == toBlack {

            return Color.black.title

        } else {

            return ""
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

        guard let dateSection = components.index(of: Component.date),
            let consumingTimeSection = components.index(of: Component.time),
            let shapeSection = components.index(of: Component.shape),
            let colorSection = components.index(of: Component.color),
            let amountSection = components.index(of: Component.amount),
            let medicineSection = components.index(of: Component.medicine),
            let otherSection = components.index(of: Component.other) else { return }

        let dateIndexPath = IndexPath(row: 0, section: dateSection)
        let consumingTimeIndexPath = IndexPath(row: 0, section: consumingTimeSection)
        let shapeIndexPath = IndexPath(row: 0, section: shapeSection)
        let colorIndexPath = IndexPath(row: 0, section: colorSection)
        let amountIndexPath = IndexPath(row: 0, section: amountSection)
        let medicineIndexPath = IndexPath(row: 0, section: medicineSection)
        let otherIndexPath = IndexPath(row: 0, section: otherSection)

        guard let dateCell = tableView.cellForRow(at: dateIndexPath) as? InfoTableViewCell,
            let consumingTimeCell = tableView.cellForRow(at: consumingTimeIndexPath) as? InfoTableViewCell,
            let shapeCell = tableView.cellForRow(at: shapeIndexPath) as? InfoTableViewCell,
            let colorCell = tableView.cellForRow(at: colorIndexPath) as? InfoTableViewCell,
            let amountCell = tableView.cellForRow(at: amountIndexPath) as? InfoTableViewCell,
            let medicineCell = tableView.cellForRow(at: medicineIndexPath) as? InfoTableViewCell,
            let otherCell = tableView.cellForRow(at: otherIndexPath) as? InfoTableViewCell else { return }

        if let date = dateCell.rowView.infoTextField.text?.substring(to: 10) {

            finalCaca.date = date

        }

        if let time = dateCell.rowView.infoTextField.text?.substring(from: 11) {

            finalCaca.time = time

        }

        if let consumingTime = consumingTimeCell.rowView.infoTextField.text {

            finalCaca.consumingTime = consumingTime

        }

        if let shape = shapeCell.rowView.infoTextField.text {

            finalCaca.shape = shape

        }

        if let color = colorCell.rowView.infoTextField.text {

            finalCaca.color = color

        }

        if let amount = amountCell.rowView.infoTextField.text {

            finalCaca.amount = amount

        }

        if let medicine = medicineCell.rowView.infoTextField.text {

            finalCaca.medicine = medicine

        }

        if let otherInfo = otherCell.rowView.infoTextField.text {

            finalCaca.otherInfo = otherInfo

        }

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

        guard let consumingTimeSection = components.index(of: Component.time),
            let shapeSection = components.index(of: Component.shape),
            let colorSection = components.index(of: Component.color) else { return }

        let consumingTimeIndexPath = IndexPath(row: 0, section: consumingTimeSection)
        let shapeIndexPath = IndexPath(row: 0, section: shapeSection)
        let colorIndexPath = IndexPath(row: 0, section: colorSection)

        guard let consumingTimeCell = tableView.cellForRow(at: consumingTimeIndexPath) as? InfoTableViewCell,
            let shapeCell = tableView.cellForRow(at: shapeIndexPath) as? InfoTableViewCell,
            let colorCell = tableView.cellForRow(at: colorIndexPath) as? InfoTableViewCell else { return }

        switch pickerView {

        case timePicker:

            switch component {

            case 0: finalHour = String(format: "%02i", hour[row])

            case 1: finalMin = String(format: "%02i", min[row])

            case 2: finalSec = String(format: "%02i", sec[row])

            default: break

            }

            consumingTimeCell.rowView.infoTextField.text = "\(finalHour):\(finalMin):\(finalSec)"
            finalCaca.consumingTime = "\(finalHour):\(finalMin):\(finalSec)"

        case shapePicker:

            shapeCell.rowView.infoTextField.text = shapes[row].title
            finalCaca.shape = shapes[row].title

        case colorPicker:

            colorCell.rowView.infoTextField.text = colors[row].title
            finalCaca.color = colors[row].title

        default: break

        }
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        switch pickerView {

        case timePicker:

            let pickerLabel = UILabel()

            switch component {

            case 0:
                pickerLabel.text = String(format: "%02i", hour[row])

            case 1:
                pickerLabel.text = String(format: "%02i", min[row])

            case 2:
                pickerLabel.text = String(format: "%02i", sec[row])

            default: break

            }

            pickerLabel.font = UIFont(name: "Futura-Bold", size: 20)

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

}
