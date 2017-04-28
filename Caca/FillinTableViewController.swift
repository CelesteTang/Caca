//
//  FillinTableViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/18.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit
import Firebase
import ColorThiefSwift

class FillinTableViewController: UITableViewController {

    var isFromCaca = false

    var isFromRecord = false

    var isFromRecordDetail = false

    enum Component: Int {

        case photo, date, time, shape, color, amount, other, finish

        var title: String {

            switch self {
            case .date:
                return "Date"
            case .time:
                return "Time"
            case .shape:
                return "Shape"
            case .color:
                return "Color"
            case .amount:
                return "Amount"
            case .other:
                return "Other"
            default:
                return ""
            }
        }
    }

    // MARK: Property

    let components: [Component] = [.photo, .date, .time, .shape, .color, .amount, .other, .finish]

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

    var finalCaca = FinalCaca(date: "", time: "", consumingTime: "", shape: "", color: "", amount: "", otherInfo: "", image: #imageLiteral(resourceName: "caca-big"))

    var cacas = [Caca]()

    var advice = String()

    var shapeAdvice = String()

    var colorAdvice = String()

    var frequencyAdvice = String()

    var recievedCacaFromRecordDetail = [Caca]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: "PhotoTableViewCell")
        self.tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: "InfoTableViewCell")
        self.tableView.register(FinishTableViewCell.self, forCellReuseIdentifier: "FinishTableViewCell")

        self.tableView.allowsSelection = false
        self.tableView.separatorStyle = .none

        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)

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
        let thumbIamge = self.resizeImage(image: #imageLiteral(resourceName: "caca-big"), targetRatio: 0.1)
        self.amountSlider.setThumbImage(thumbIamge, for: .normal)
        let plusImage = self.resizeImage(image: #imageLiteral(resourceName: "plus"), targetRatio: 0.5)
        let minusImage = self.resizeImage(image: #imageLiteral(resourceName: "minus"), targetRatio: 0.5)
        self.amountSlider.maximumValueImage = plusImage.withRenderingMode(.alwaysTemplate)
        self.amountSlider.minimumValueImage = minusImage.withRenderingMode(.alwaysTemplate)
        self.amountSlider.tintColor = Palette.darkblue
        self.amountSlider.minimumValue = 0.05
        self.amountSlider.maximumValue = 0.15
        self.amountSlider.value = 0.1
        self.amountSlider.addTarget(self, action: #selector(changeThumbImageSize), for: .valueChanged)

    }

    func datePickerChanged() {

        if let dateCell = tableView.visibleCells[Component.date.rawValue] as? InfoTableViewCell {

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"

            dateCell.rowView.infoTextField.text = formatter.string(from: datePicker.date)

        }
    }

    func changeThumbImageSize() {

        let thumbImage: UIImage = #imageLiteral(resourceName: "caca-big")

        if let amountCell = tableView.visibleCells[Component.amount.rawValue] as? InfoTableViewCell {

            switch self.amountSlider.value {
            case 0.11...0.15:

                let newImage = self.resizeImage(image: thumbImage, targetRatio: 0.15)
                amountCell.rowView.infoTextField.text = "Large"
                self.amountSlider.setThumbImage(newImage, for: .normal)

            case 0.08..<0.11:

                let newImage = self.resizeImage(image: thumbImage, targetRatio: 0.10)
                amountCell.rowView.infoTextField.text = "Normal"
                self.amountSlider.setThumbImage(newImage, for: .normal)

            case 0.05..<0.08:

                let newImage = self.resizeImage(image: thumbImage, targetRatio: 0.05)
                amountCell.rowView.infoTextField.text = "Small"
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

        case .photo, .date, .time, .shape, .color, .amount, .other, .finish:

            return 1

        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let component = components[indexPath.section]

        switch component {

        case .photo:

            return 200.0

        case .date, .time, .shape, .color, .amount, .other:

            return 80.0

        case .finish:

            return 100.0

        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let photoCell = tableView.visibleCells[Component.photo.rawValue] as? PhotoTableViewCell else { return }

        if photoCell.rowView.cacaPhotoImageView.image != #imageLiteral(resourceName: "caca-big") {

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

        guard let dateCell = tableView.visibleCells[Component.date.rawValue] as? InfoTableViewCell,
            let timeCell = tableView.visibleCells[Component.time.rawValue] as? InfoTableViewCell,
            let shapeCell = tableView.visibleCells[Component.shape.rawValue] as? InfoTableViewCell,
            let colorCell = tableView.visibleCells[Component.color.rawValue] as? InfoTableViewCell,
            let amountCell = tableView.visibleCells[Component.amount.rawValue] as? InfoTableViewCell else { return }

        if dateCell.rowView.infoTextField.text == "" {

            let alertController = UIAlertController(title: "Warning",
                                                    message: "Please enter the date",
                                                    preferredStyle: UIAlertControllerStyle.alert)

            alertController.addAction(UIAlertAction(title: "OK",
                                                    style: UIAlertActionStyle.default,
                                                    handler: nil))

            self.present(alertController, animated: true, completion: nil)

        } else if timeCell.rowView.infoTextField.text == "" {

            let alertController = UIAlertController(title: "Warning",
                                                    message: "Please enter the time",
                                                    preferredStyle: UIAlertControllerStyle.alert)

            alertController.addAction(UIAlertAction(title: "OK",
                                                    style: UIAlertActionStyle.default,
                                                    handler: nil))

            self.present(alertController, animated: true, completion: nil)

        } else if shapeCell.rowView.infoTextField.text == "" {

            let alertController = UIAlertController(title: "Warning",
                                                    message: "Please enter the shape",
                                                    preferredStyle: UIAlertControllerStyle.alert)

            alertController.addAction(UIAlertAction(title: "OK",
                                                    style: UIAlertActionStyle.default,
                                                    handler: nil))

            self.present(alertController, animated: true, completion: nil)

        } else if colorCell.rowView.infoTextField.text == "" {

            let alertController = UIAlertController(title: "Warning",
                                                    message: "Please enter the color",
                                                    preferredStyle: UIAlertControllerStyle.alert)

            alertController.addAction(UIAlertAction(title: "OK",
                                                    style: UIAlertActionStyle.default,
                                                    handler: nil))

            self.present(alertController, animated: true, completion: nil)

        } else if amountCell.rowView.infoTextField.text == "" {

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

        guard let shapeCell = tableView.visibleCells[Component.shape.rawValue] as? InfoTableViewCell,
              let colorCell = tableView.visibleCells[Component.color.rawValue] as? InfoTableViewCell,
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

        guard let photoCell = tableView.visibleCells[Component.photo.rawValue] as? PhotoTableViewCell,
            let dateCell = tableView.visibleCells[Component.date.rawValue] as? InfoTableViewCell,
            let amountCell = tableView.visibleCells[Component.amount.rawValue] as? InfoTableViewCell,
            let otherCell = tableView.visibleCells[Component.other.rawValue] as? InfoTableViewCell,
            let finishCell = tableView.visibleCells[Component.finish.rawValue] as? FinishTableViewCell
            else { return }

        finishCell.rowView.finishButton.isEnabled = false

        guard let hostUID = FIRAuth.auth()?.currentUser?.uid,
            let date = dateCell.rowView.infoTextField.text?.substring(to: 10),
            let time = dateCell.rowView.infoTextField.text?.substring(from: 11),
            let amount = amountCell.rowView.infoTextField.text,
            let other = otherCell.rowView.infoTextField.text else {

                return

        }

        let cacaID = FIRDatabase.database().reference().child("cacas").childByAutoId().key
        let photoID = UUID().uuidString
        let overallAdvice = getAdvice()

        finalCaca.date = date
        finalCaca.time = time
        finalCaca.amount = amount
        finalCaca.otherInfo = other

        // MARK : Create caca with photo

        if photoCell.rowView.cacaPhotoImageView.image != #imageLiteral(resourceName: "caca-big") {

            CacaProvider.shared.saveCacaPhoto(image: finalCaca.image, photoID: photoID, completion: { (cacaPhotoUrl, error) in

                if error != nil {

                    print(error?.localizedDescription ?? "storageError")

                    return
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
                             "advice": overallAdvice] as [String : Any]

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
                         "advice": overallAdvice] as [String : Any]

            CacaProvider.shared.saveCaca(cacaID: cacaID, value: value)

            self.switchToRecord()

        }

    }

    func editCaca() {

        guard let photoCell = tableView.visibleCells[Component.photo.rawValue] as? PhotoTableViewCell,
            let dateCell = tableView.visibleCells[Component.date.rawValue] as? InfoTableViewCell,
            let amountCell = tableView.visibleCells[Component.amount.rawValue] as? InfoTableViewCell,
            let otherCell = tableView.visibleCells[Component.other.rawValue] as? InfoTableViewCell,
            let finishCell = tableView.visibleCells[Component.finish.rawValue] as? FinishTableViewCell else {

                return

        }

        finishCell.rowView.finishButton.isEnabled = false

        guard let hostUID = FIRAuth.auth()?.currentUser?.uid,
            let date = dateCell.rowView.infoTextField.text?.substring(to: 10),
            let time = dateCell.rowView.infoTextField.text?.substring(from: 11),
            let amount = amountCell.rowView.infoTextField.text,
            let other = otherCell.rowView.infoTextField.text else {

                return

        }

        let cacaID = recievedCacaFromRecordDetail[0].cacaID
        let photoID = recievedCacaFromRecordDetail[0].photoID
        let overallAdvice = getAdvice()

        finalCaca.date = date
        finalCaca.time = time
        finalCaca.amount = amount
        finalCaca.otherInfo = other

        // MARK : Edit caca with new photo (had old photo)

        if photoCell.rowView.cacaPhotoImageView.image != #imageLiteral(resourceName: "caca-big") && recievedCacaFromRecordDetail[0].photoID != "" {

            CacaProvider.shared.editCacaPhoto(image: finalCaca.image, photoID: photoID, completion: { (cacaPhotoUrl, storageError, deleteError) in

                if storageError != nil {

                    print(storageError?.localizedDescription ?? "storageError")

                    return
                }

                if deleteError != nil {

                    print(deleteError?.localizedDescription ?? "deleteError")

                    return
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
                             "advice": overallAdvice] as [String : Any]

                CacaProvider.shared.editCaca(cacaID: cacaID, value: value)

                self.switchToRecord()

            })

        } else if photoCell.rowView.cacaPhotoImageView.image != #imageLiteral(resourceName: "caca-big") && recievedCacaFromRecordDetail[0].photoID == "" {

            // MARK : Edit caca with new photo (no old photo)

            CacaProvider.shared.saveCacaPhoto(image: finalCaca.image, photoID: photoID, completion: { (cacaPhotoUrl, error) in

                if error != nil {

                    print(error?.localizedDescription ?? "storageError")

                    return
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
                             "advice": overallAdvice] as [String : Any]

                CacaProvider.shared.editCaca(cacaID: cacaID, value: value)

                self.switchToRecord()

            })

        } else if photoCell.rowView.cacaPhotoImageView.image == #imageLiteral(resourceName: "caca-big") {

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
                         "advice": overallAdvice] as [String : Any]

            CacaProvider.shared.editCaca(cacaID: cacaID, value: value)
            self.switchToRecord()

        }

    }
}

extension FillinTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        guard let cell = tableView.visibleCells.first as? PhotoTableViewCell else { return }

        if let editedCacaImage = info[UIImagePickerControllerEditedImage] as? UIImage {

            cell.rowView.cacaPhotoImageView.image = editedCacaImage

            finalCaca.image = editedCacaImage

            guard let dominantColor = ColorThief.getColor(from: editedCacaImage) else { return }

            cell.rowView.detectionColorImageView.backgroundColor = dominantColor.makeUIColor()

        } else if let originalCacaImage = info[UIImagePickerControllerOriginalImage] as? UIImage {

            cell.rowView.cacaPhotoImageView.image = originalCacaImage

            finalCaca.image = originalCacaImage

            guard let dominantColor = ColorThief.getColor(from: originalCacaImage) else { return }

            cell.rowView.detectionColorImageView.backgroundColor = dominantColor.makeUIColor()

        }

        dismiss(animated: true, completion: nil)
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

        guard let otherCell = tableView.visibleCells[Component.other.rawValue] as? InfoTableViewCell else { return }

        finalCaca.otherInfo = otherCell.rowView.infoTextField.text

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

        if let timeCell = tableView.visibleCells[Component.time.rawValue] as? InfoTableViewCell,
            let shapeCell = tableView.visibleCells[Component.shape.rawValue] as? InfoTableViewCell,
            let colorCell = tableView.visibleCells[Component.color.rawValue] as? InfoTableViewCell {

            switch pickerView {

            case timePicker:

                switch component {

                case 0: finalHour = String(format: "%02i", hour[row])

                case 1: finalMin = String(format: "%02i", min[row])

                case 2: finalSec = String(format: "%02i", sec[row])

                default: break

                }

                timeCell.rowView.infoTextField.text = "\(finalHour):\(finalMin):\(finalSec)"
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
