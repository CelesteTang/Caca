//
//  FillinViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/22.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit
import Firebase
import ColorThiefSwift

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

    @IBOutlet weak var cancelButton: UIButton!

    @IBOutlet weak var colorView: UIView!

    @IBOutlet weak var cacaPhoto: UIImageView!

    @IBOutlet weak var photoButton: UIButton!

    @IBOutlet weak var photoLibraryButton: UIButton!

    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var consumingTimeLabel: UILabel!

    @IBOutlet weak var shapeSegmentedControl: UISegmentedControl!

    @IBOutlet weak var colorSegmentedControll: UISegmentedControl!

    @IBOutlet weak var amountSlider: UISlider!

    @IBOutlet weak var otherTextView: UITextView!

    @IBOutlet weak var finishButton: UIButton!

    var ispassed = false

    var isclicked = false

    var cacas = [Caca]()

    @IBAction func cancelFillin(_ sender: UIButton) {

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? TabBarController {

            appDelegate.window?.rootViewController = tabBarController

        }
    }

    @IBAction func pickPhotoFromLibrary(_ sender: UIButton) {

        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.videoQuality = .typeLow
        self.present(picker, animated: true, completion: nil)

        isclicked = true

    }

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

        guard let hostUID = FIRAuth.auth()?.currentUser?.uid,
              let date = dateLabel.text,
              let time = timeLabel.text,
              let consumingTime = consumingTimeLabel.text else {

            return

        }

        if (self.colorSegmentedControll.selectedSegmentIndex == Color.lightBrown.rawValue || self.colorSegmentedControll.selectedSegmentIndex == Color.darkBrown.rawValue) && (self.shapeSegmentedControl.selectedSegmentIndex == Shape.crackSausage.rawValue || self.shapeSegmentedControl.selectedSegmentIndex == Shape.smoothSausage.rawValue) {

            ispassed = true

        }

        let cacaID = FIRDatabase.database().reference().child("cacas").childByAutoId().key

        if isclicked == true {

            CacaProvider.shared.saveCacaPhoto(of: cacaPhoto.image!, completion: { (cacaPhotoUrl, error) in
                
                if error != nil {
                    
                    print(error?.localizedDescription ?? "storageError")
                    
                    return
                }
                
                let value = ["host": hostUID,
                             "date": date,
                             "time": time,
                             "consumingTime": consumingTime,
                             "shape": self.shapeSegmentedControl.selectedSegmentIndex,
                             "color": self.colorSegmentedControll.selectedSegmentIndex,
                             "amount": Double(self.amountSlider.value),
                             "other": self.otherTextView.text,
                             "photo": cacaPhotoUrl,
                             "grading": self.ispassed,
                             "cacaID": cacaID,
                             "photoID": ""] as [String : Any]
                
                CacaProvider.shared.saveCaca(cacaID: cacaID, value: value)
                self.switchToRecord()

            })

        } else {

            let value = ["host": hostUID,
                         "date": date,
                         "time": time,
                         "consumingTime": consumingTime,
                         "shape": self.shapeSegmentedControl.selectedSegmentIndex,
                         "color": self.colorSegmentedControll.selectedSegmentIndex,
                         "amount": Double(self.amountSlider.value),
                         "other": self.otherTextView.text,
                         "photo": "",
                         "grading": self.ispassed,
                         "cacaID": cacaID,
                         "photoID": ""] as [String : Any]

            CacaProvider.shared.saveCaca(cacaID: cacaID, value: value)
            self.switchToRecord()
        }
    }

    func switchToRecord() {

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? TabBarController {

            tabBarController.selectedIndex = TabBarItemType.record.rawValue

            appDelegate.window?.rootViewController = tabBarController

        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()

        ispassed = false

        isclicked = false

        otherTextView.delegate = self

        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)

        finishButton.isEnabled = true
    }

    // MARK: Set Up

    private func setUp() {

        self.view.backgroundColor = Palette.backgoundColor

        self.cancelButton.setTitle("Cancel", for: .normal)

        self.cacaPhoto.image = #imageLiteral(resourceName: "poo-icon")
        self.cacaPhoto.backgroundColor = Palette.backgoundColor

        self.photoButton.setTitle("Take photo", for: .normal)
        self.photoLibraryButton.setTitle("Pick photo from library", for: .normal)

        let time = Time()
        self.dateLabel.text = time.dateString()
        self.timeLabel.text = time.timeString()
        self.consumingTimeLabel.text = Time.consumingTime

        self.amountSlider.thumbTintColor = Palette.textColor
        self.amountSlider.tintColor = UIColor.white
        self.amountSlider.minimumValue = 1.0
        self.amountSlider.maximumValue = 3.0
        self.amountSlider.value = 2.0

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

            guard let dominantColor = ColorThief.getColor(from: editedCacaImage) else {
                return
            }

            self.colorView.backgroundColor = dominantColor.makeUIColor()

        } else if let originalCacaImage = info[UIImagePickerControllerOriginalImage] as? UIImage {

            self.cacaPhoto.image = originalCacaImage

            guard let dominantColor = ColorThief.getColor(from: originalCacaImage) else {
                return
            }

            self.colorView.backgroundColor = dominantColor.makeUIColor()

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

        if textView == self.otherTextView {

            self.view.bounds = CGRect(x: 0, y: 250, width: self.view.frame.size.width, height: self.view.frame.size.height)

        }

        return true

    }

    func textViewDidEndEditing(_ textView: UITextView) {

        self.view.bounds = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)

    }
}
