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

            return #imageLiteral(resourceName: "poo-icon")
//            return UIImage(named: "")!.withRenderingMode(.alwaysTemplate)

        case .lumpySausage:

            return #imageLiteral(resourceName: "poo-icon")

        case .crackSausage:

            return #imageLiteral(resourceName: "poo-icon")

        case .smoothSausage:

            return #imageLiteral(resourceName: "poo-icon")

        case .softBlob:

            return #imageLiteral(resourceName: "poo-icon")

        case .mushyStool:

            return #imageLiteral(resourceName: "poo-icon")

        case .wateryStool:

            return #imageLiteral(resourceName: "poo-icon")
        }

    }

}

enum Color: Int {

    case red, yellow, green, lightBrown, darkBrown, gray, black

    var image: UIImage {

        switch self {
        case .red:

            return #imageLiteral(resourceName: "poo-icon")

        case .yellow:

            return #imageLiteral(resourceName: "poo-icon")
        case .green:

            return #imageLiteral(resourceName: "poo-icon")

        case .lightBrown:

            return #imageLiteral(resourceName: "poo-icon")

        case .darkBrown:

            return #imageLiteral(resourceName: "poo-icon")

        case .gray:

            return #imageLiteral(resourceName: "poo-icon")

        case .black:

            return #imageLiteral(resourceName: "poo-icon")
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

    var cacas = [Caca]()

    var advice = String()

    var frequencyAdvice = String()

    var shapeAdvice = String()

    var colorAdvice = String()

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

    }

    @IBAction func didFillin(_ sender: UIButton) {

        finishButton.isEnabled = false

        guard let hostUID = FIRAuth.auth()?.currentUser?.uid,
              let date = dateLabel.text,
              let time = timeLabel.text,
              let consumingTime = consumingTimeLabel.text else {

            return

        }

        let cacaID = FIRDatabase.database().reference().child("cacas").childByAutoId().key
        let photoID = UUID().uuidString
        let overallAdvice = getAdvice()

        if cacaPhoto.image != #imageLiteral(resourceName: "poo-icon") {

            CacaProvider.shared.saveCacaPhoto(of: cacaPhoto.image!, with: photoID, completion: { (cacaPhotoUrl, error) in

                if error != nil {

                    print(error?.localizedDescription ?? "storageError")

                    return
                }

                guard let cacaPhotoUrl = cacaPhotoUrl else { return }
                let value = ["host": hostUID,
                             "cacaID": cacaID,
                             "photo": cacaPhotoUrl,
                             "photoID": photoID,
                             "date": date,
                             "time": time,
                             "consumingTime": consumingTime,
                             "shape": self.shapeSegmentedControl.selectedSegmentIndex,
                             "color": self.colorSegmentedControll.selectedSegmentIndex,
                             "amount": Double(self.amountSlider.value),
                             "other": self.otherTextView.text,
                             "grading": self.ispassed,
                             "advice": overallAdvice] as [String : Any]

                CacaProvider.shared.saveCaca(cacaID: cacaID, value: value)
                self.switchToRecord()

            })

        } else {

            let value = ["host": hostUID,
                         "cacaID": cacaID,
                         "photo": "",
                         "photoID": "",
                         "date": date,
                         "time": time,
                         "consumingTime": consumingTime,
                         "shape": self.shapeSegmentedControl.selectedSegmentIndex,
                         "color": self.colorSegmentedControll.selectedSegmentIndex,
                         "amount": Double(self.amountSlider.value),
                         "other": self.otherTextView.text,
                         "grading": self.ispassed,
                         "advice": overallAdvice] as [String : Any]

            CacaProvider.shared.saveCaca(cacaID: cacaID, value: value)
            self.switchToRecord()
        }
    }

    func getAdvice() -> String {

        if (self.colorSegmentedControll.selectedSegmentIndex == Color.lightBrown.rawValue || self.colorSegmentedControll.selectedSegmentIndex == Color.darkBrown.rawValue) && (self.shapeSegmentedControl.selectedSegmentIndex == Shape.crackSausage.rawValue || self.shapeSegmentedControl.selectedSegmentIndex == Shape.smoothSausage.rawValue) {

            ispassed = true

            self.advice = "Good caca! Please keep it up!"

        } else {

            self.advice = "Warning! There might be some problems in your caca... "

            switch Shape(rawValue: self.shapeSegmentedControl.selectedSegmentIndex)! {

            case .separateHard, .lumpySausage:

                self.shapeAdvice = "You are constipated, and "

            case .crackSausage, .smoothSausage:

                self.shapeAdvice = "The shape of your caca is good, but "

            case .softBlob, .mushyStool, .wateryStool:

                self.shapeAdvice = "You have diarrhea, and "

            }

            switch Color(rawValue: self.colorSegmentedControll.selectedSegmentIndex)! {

            case .red:

                self.colorAdvice = "the color of your caca is red."

            case .yellow:

                self.colorAdvice = "the color of your caca is yellow."

            case .green:

                self.colorAdvice = "the color of your caca is green."

            case .lightBrown, .darkBrown:

                self.colorAdvice = "the color of your caca is good!"

            case .gray:

                self.colorAdvice = "the color of your caca is gray."

            case .black:

                self.colorAdvice = "the color of your caca is black."

            }

        }

        let overallAdvice = self.advice + self.frequencyAdvice + self.shapeAdvice + self.colorAdvice

        return overallAdvice
    }

    func switchToRecord() {

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? TabBarController {

            tabBarController.selectedIndex = TabBarItemType.record.rawValue

            appDelegate.window?.rootViewController = tabBarController

        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        print(advice)
        print(frequencyAdvice)
        print(colorAdvice)
        print(shapeAdvice)

        setUp()

        ispassed = false

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

        self.amountSlider.isContinuous = true
        let thumbIamge = self.resizeImage(image: #imageLiteral(resourceName: "poo-icon"), targetRatio: 0.75)
        self.amountSlider.setThumbImage(thumbIamge, for: .normal)
        self.amountSlider.tintColor = UIColor.white
        self.amountSlider.minimumValue = 0.5
        self.amountSlider.maximumValue = 1.0
        self.amountSlider.value = 0.75
        self.amountSlider.addTarget(self, action: #selector(changeThumbImageSize), for: .valueChanged)

    }

    func hideKeyBoard() {

        self.otherTextView.resignFirstResponder()

    }

    func changeThumbImageSize() {

        let ratio: CGFloat = CGFloat(self.amountSlider.value)
        let thumbImage: UIImage = #imageLiteral(resourceName: "poo-icon")

//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: thumbImage.size.width * ratio, height: thumbImage.size.height * ratio))
//        imageView.image = thumbImage
//        self.amountSlider.addSubview(imageView)

        let newImage = self.resizeImage(image: thumbImage, targetRatio: ratio)

        self.amountSlider.setThumbImage(newImage, for: .normal)
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
}

extension FillinViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let editedCacaImage = info[UIImagePickerControllerEditedImage] as? UIImage {

            self.cacaPhoto.image = editedCacaImage

            guard let dominantColor = ColorThief.getColor(from: editedCacaImage) else { return }

            self.colorView.backgroundColor = dominantColor.makeUIColor()

        } else if let originalCacaImage = info[UIImagePickerControllerOriginalImage] as? UIImage {

            self.cacaPhoto.image = originalCacaImage

            guard let dominantColor = ColorThief.getColor(from: originalCacaImage) else { return }

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
