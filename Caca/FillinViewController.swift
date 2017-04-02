//
//  FillinViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/22.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit
import Firebase

enum Shape: Int {

    case separateHard, lumpySausage, crackSausage, smoothSausage, softBlob, mushyStool, wateryStool

    var image: UIImage {

        switch self {
        case .separateHard:

            return #imageLiteral(resourceName: "poo-icon").withRenderingMode(.alwaysTemplate)
//            return UIImage(named: "")!.withRenderingMode(.alwaysTemplate)

        case .lumpySausage:

            return #imageLiteral(resourceName: "poo-icon").withRenderingMode(.alwaysTemplate)

        case .crackSausage:

            return #imageLiteral(resourceName: "poo-icon").withRenderingMode(.alwaysTemplate)

        case .smoothSausage:

            return #imageLiteral(resourceName: "poo-icon").withRenderingMode(.alwaysTemplate)

        case .softBlob:

            return #imageLiteral(resourceName: "poo-icon").withRenderingMode(.alwaysTemplate)

        case .mushyStool:

            return #imageLiteral(resourceName: "poo-icon").withRenderingMode(.alwaysTemplate)

        case .wateryStool:

            return #imageLiteral(resourceName: "poo-icon").withRenderingMode(.alwaysTemplate)
        }

    }

}

enum Color: Int {

    case red, yellow, green, lightBrown, darkBrown, gray, black

    var image: UIImage {

        switch self {
        case .red:

            return #imageLiteral(resourceName: "poo-icon").withRenderingMode(.alwaysTemplate)

        case .yellow:

            return #imageLiteral(resourceName: "poo-icon").withRenderingMode(.alwaysTemplate)
        case .green:

            return #imageLiteral(resourceName: "poo-icon").withRenderingMode(.alwaysTemplate)

        case .lightBrown:

            return #imageLiteral(resourceName: "poo-icon").withRenderingMode(.alwaysTemplate)

        case .darkBrown:

            return #imageLiteral(resourceName: "poo-icon").withRenderingMode(.alwaysTemplate)

        case .gray:

            return #imageLiteral(resourceName: "poo-icon").withRenderingMode(.alwaysTemplate)

        case .black:

            return #imageLiteral(resourceName: "poo-icon").withRenderingMode(.alwaysTemplate)
        }

    }

}

class FillinViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var cacaPhoto: UIImageView!

    @IBOutlet weak var photoButton: UIButton!

    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var consumingTimeLabel: UILabel!

    @IBOutlet weak var shapeSegmentedControl: UISegmentedControl!

    @IBOutlet weak var colorSegmentedControll: UISegmentedControl!

    @IBOutlet weak var amountSlider: UISlider!

    @IBOutlet weak var otherTextView: UITextView!

    @IBOutlet weak var finishButton: UIButton!

    var isclicked = false

    var cacas = [Caca]()

    @IBAction func addPhoto(_ sender: UIButton) {

        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.cameraDevice = .rear
        picker.cameraFlashMode = .on
        picker.allowsEditing = true
        picker.videoQuality = .typeLow
        self.present(picker, animated: true, completion: nil)

        isclicked = true

    }

    @IBAction func amountChanged(_ sender: UISlider) {

    }

    @IBAction func didFillin(_ sender: UIButton) {

        finishButton.isEnabled = false

        guard let hostUID = FIRAuth.auth()?.currentUser?.uid, let date = dateLabel.text, let time = timeLabel.text, let consumingTime = consumingTimeLabel.text else {
            return
        }

        let storageRef = FIRStorage.storage().reference().child(hostUID).child("\(UUID().uuidString).png")

        if isclicked == true {

            if let uploadData = UIImageJPEGRepresentation(cacaPhoto.image!, 0.1) {

                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in

                    if error != nil {

                        print(error?.localizedDescription ?? "storageError")

                        return
                    }

                    if let cacaPhotoUrl = metadata?.downloadURL()?.absoluteString {

                        let value = ["host": hostUID,
                                     "date": date,
                                     "time": time,
                                     "consumingTime": consumingTime,
                                     "shape": self.shapeSegmentedControl.selectedSegmentIndex,
                                     "color": self.colorSegmentedControll.selectedSegmentIndex,
                                     "amount": Double(self.amountSlider.value),
                                     "other": self.otherTextView.text,
                                     "photo": cacaPhotoUrl] as [String : Any]

                        self.saveCacaIntoDatabase(value: value)

                    }
                })
            }

        } else {

            let value = ["host": hostUID,
                         "date": date,
                         "time": time,
                         "consumingTime": consumingTime,
                         "shape": self.shapeSegmentedControl.selectedSegmentIndex,
                         "color": self.colorSegmentedControll.selectedSegmentIndex,
                         "amount": Double(self.amountSlider.value),
                         "other": self.otherTextView.text,
                         "photo": ""] as [String : Any]

            self.saveCacaIntoDatabase(value: value)

        }
    }

    private func saveCacaIntoDatabase(value: [String : Any]) {

        let databaseRef = FIRDatabase.database().reference().child("cacas").childByAutoId()

        databaseRef.updateChildValues(value, withCompletionBlock: { (error, _) in

//            snapshot.observeSingleEvent(of: .value, with: {snap in
//                print(snap)
//                self.switchToRecord(snap)
//
//            })

            if error != nil {

                print(error?.localizedDescription ?? "")

                return
            }

            self.switchToRecord()

        })
    }

    func switchToRecord() {

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? TabBarController {

            tabBarController.selectedIndex = 1

//            let recordTableViewController  = tabBarController.selectedViewController as? RecordTableViewController
//
//            if let cacaInfo = snap.value as? NSDictionary,
//                let cacaPhoto = cacaInfo["photo"] as? String,
//                let cacaDate = cacaInfo["date"] as? String,
//                let cacaTime = cacaInfo["time"] as? String,
//                let cacaConsumingTime = cacaInfo["consumingTime"] as? String,
//                let cacaShape = cacaInfo["shape"] as? Int,
//                let cacaColor = cacaInfo["color"] as? Int,
//                let cacaAmount = cacaInfo["amount"] as? Double,
//                let cacaOther = cacaInfo["other"] as? String {
//
//                let caca = Caca(photo: cacaPhoto, date: cacaDate, time: cacaTime, consumingTime: cacaConsumingTime, shape: Shape(rawValue: cacaShape)!, color: Color(rawValue: cacaColor)!, amount: cacaAmount, otherInfo: cacaOther)
//
//                recordTableViewController?.cacas.append(caca)

            appDelegate.window?.rootViewController = tabBarController

        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        otherTextView.delegate = self

        isclicked = false

        cacaPhoto.image = #imageLiteral(resourceName: "poo-icon")
        cacaPhoto.backgroundColor = Palette.backgoundColor

        photoButton.setTitle("Take photo", for: .normal)

        dateLabel.text = dateString()
        timeLabel.text = timeString()
        consumingTimeLabel.text = Time.consumingTime
        view.backgroundColor = Palette.backgoundColor

        amountSlider.thumbTintColor = Palette.textColor
        amountSlider.tintColor = UIColor.white
        amountSlider.minimumValue = 1.0
        amountSlider.maximumValue = 3.0
        amountSlider.value = 2.0

        otherTextView.delegate = self

        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)

        finishButton.isEnabled = true
    }

    func dateString() -> String {

        let date = Date()
        let calendar = Calendar.current

        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)

        return String(format: "%04i-%02i-%02i", year, month, day)

    }

    func timeString() -> String {

        let date = Date()
        let calendar = Calendar.current

        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)

        return String(format: "%02i:%02i", hour, minute)

    }

    func hideKeyBoard() {
        self.otherTextView.resignFirstResponder()
    }

}

extension FillinViewController: UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let mediaType = info[UIImagePickerControllerMediaType] as? String {
            print(mediaType)
        }

        if let editedCacaImage = info[UIImagePickerControllerEditedImage] as? UIImage {

            self.cacaPhoto.image = editedCacaImage

        } else if let originalCacaImage = info[UIImagePickerControllerOriginalImage] as? UIImage {

            self.cacaPhoto.image = originalCacaImage

        }

        dismiss(animated: true, completion: nil)
    }
}

extension FillinViewController: UITextViewDelegate {

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {

        self.view.endEditing(true)

        return true
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {

        if textView == otherTextView {

                self.view.bounds = CGRect(x: 0, y: 250, width: self.view.frame.size.width, height: self.view.frame.size.height)

        }

        return true

    }

    func textViewDidEndEditing(_ textView: UITextView) {

        self.view.bounds = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)

    }
}
