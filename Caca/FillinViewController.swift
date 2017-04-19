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

var isFromCaca = false

var isFromRecord = false

class FillinViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIButton!

    @IBOutlet weak var colorView: UIView!

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

    var ispassed = false

    var cacas = [Caca]()

    var advice = String()

    var shapeAdvice = String()

    var colorAdvice = String()

    var frequencyAdvice = String()

    @IBAction func cancelFillin(_ sender: UIButton) {

        if isFromCaca == true {

            isFromCaca = false

            if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? TabBarController {

                appDelegate.window?.rootViewController = tabBarController

            }

        } else if isFromRecord == true {

            isFromRecord = false

            dismiss(animated: true, completion: nil)

        }
    }

    @IBAction func addPhoto(_ sender: UIButton) {

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

        // MARK: Pass or Fail

        if (self.colorSegmentedControll.selectedSegmentIndex == Color.lightBrown.rawValue || self.colorSegmentedControll.selectedSegmentIndex == Color.darkBrown.rawValue) && (self.shapeSegmentedControl.selectedSegmentIndex == Shape.crackSausage.rawValue || self.shapeSegmentedControl.selectedSegmentIndex == Shape.smoothSausage.rawValue) {

            ispassed = true

            self.advice = "Good caca! Please keep it up!"

        } else {

            self.advice = "Warning! Your caca may not healthy! "

            // MARK: Shape

            switch Shape(rawValue: self.shapeSegmentedControl.selectedSegmentIndex)! {

            case .separateHard, .lumpySausage:

                self.shapeAdvice = "You are constipated, and "

            case .crackSausage, .smoothSausage:

                self.shapeAdvice = "The shape of your caca is good, but "

            case .softBlob, .mushyStool, .wateryStool:

                self.shapeAdvice = "You have diarrhea, and "

            }

            // MARK: Color

            switch Color(rawValue: self.colorSegmentedControll.selectedSegmentIndex)! {

            case .red:

                self.colorAdvice = "the color of your caca is red. "

            case .yellow:

                self.colorAdvice = "the color of your caca is yellow. "

            case .green:

                self.colorAdvice = "the color of your caca is green. "

            case .lightBrown, .darkBrown:

                self.colorAdvice = "the color of your caca is good! "

            case .gray:

                self.colorAdvice = "the color of your caca is gray. "

            case .black:

                self.colorAdvice = "the color of your caca is black. "

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

        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? TabBarController {

            tabBarController.selectedIndex = TabBarItemType.record.rawValue

            appDelegate.window?.rootViewController = tabBarController

        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()

        ispassed = false

        otherTextView.delegate = self

        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyBoard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)

        finishButton.isEnabled = true

        DispatchQueue.global().async {

            CacaProvider.shared.getCaca { (cacas, _) in

                if let cacas = cacas {

                    self.cacas = cacas

                }
            }
        }

    }

    // MARK: Set Up

    private func setUp() {

        self.view.backgroundColor = Palette.backgoundColor

        self.cancelButton.setTitle("Cancel", for: .normal)

        self.cacaPhoto.image = #imageLiteral(resourceName: "poo-icon")
        self.cacaPhoto.backgroundColor = Palette.backgoundColor

        self.photoButton.setTitle("Take photo", for: .normal)

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
