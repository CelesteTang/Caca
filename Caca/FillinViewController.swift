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

    @IBOutlet weak var cacaPhoto: UIImageView!

    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var consumingTimeLabel: UILabel!

    @IBOutlet weak var shapeSegmentedControl: UISegmentedControl!

    @IBOutlet weak var colorSegmentedControll: UISegmentedControl!

    @IBOutlet weak var amountSlider: UISlider!

    @IBOutlet weak var otherTextView: UITextView!

    @IBOutlet weak var finishButton: UIButton!

    @IBAction func amountChanged(_ sender: UISlider) {
    }

    @IBAction func didFillin(_ sender: UIButton) {

        if let shape = Shape(rawValue: shapeSegmentedControl.selectedSegmentIndex), let color = Color(rawValue: colorSegmentedControll.selectedSegmentIndex) {

            let caca = Caca(date: dateString(), consumingTime: Time.consumingTime, shape: shape, color: color, amount: Double(amountSlider.value), otherInfo: "0")

            Caca.cacas.append(caca)
        }

        let rootRef = FIRDatabase.database().reference()

        let cacaRef = rootRef.child("cacas").childByAutoId()

        let value = ["host": FIRAuth.auth()?.currentUser?.uid ?? "",
                     "date": self.dateLabel.text ?? "",
                     "consumingTime": self.consumingTimeLabel.text ?? "",
                     "shape": shapeSegmentedControl.selectedSegmentIndex,
                     "color": colorSegmentedControll.selectedSegmentIndex,
                     "amount": Double(amountSlider.value),
                     "other": self.otherTextView.text,
                     "photo": ""] as [String : Any]

        cacaRef.updateChildValues(value, withCompletionBlock: { (error, _) in
                if error != nil {

                    print(error?.localizedDescription ?? "")

                    return
                }
            })

    if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? TabBarController {

            tabBarController.selectedIndex = 1
            appDelegate.window?.rootViewController = tabBarController
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dateLabel.text = dateString()
        consumingTimeLabel.text = Time.consumingTime
        view.backgroundColor = Palette.backgoundColor

        amountSlider.thumbTintColor = Palette.textColor
        amountSlider.tintColor = UIColor.white
        amountSlider.minimumValue = 1
        amountSlider.maximumValue = 3
    }

    func dateString() -> String {

        let date = Date()
        let calendar = Calendar.current

        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)

        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)

        return String(format: "%04i/%02i/%02i %02i:%02i", year, month, day, hour, minute)
    }

}
