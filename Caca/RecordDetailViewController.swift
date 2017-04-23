//
//  RecordDetailViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/23.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class RecordDetailViewController: UIViewController {

    @IBOutlet weak var cacaPhoto: UIImageView!

    @IBOutlet weak var deleteRecordButton: UIButton!

    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var consumingTimeLabel: UILabel!

    @IBOutlet weak var shapeImageView: UIImageView!

    @IBOutlet weak var shapeLabel: UILabel!

    @IBOutlet weak var colorImageView: UIImageView!

    @IBOutlet weak var colorLabel: UILabel!

    @IBOutlet weak var amountLabel: UILabel!

    @IBOutlet weak var otherInfoLabel: UILabel!

    @IBOutlet weak var passOrFailLabel: UILabel!

    @IBAction func deleteRecord(_ sender: UIButton) {

        let alertController = UIAlertController(title: "Warning",
                                                message: "Do you want to delete this record?",
                                                preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: "No",
                                         style: .cancel,
                                         handler: nil)
        alertController.addAction(cancelAction)

        let okAction = UIAlertAction(title: "Delete", style: .destructive) { _ in

            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let tabBarController = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? TabBarController {

                tabBarController.selectedIndex = TabBarItemType.record.rawValue

                CacaProvider.shared.deleteCaca(of: self.recievedCaca[0].cacaID)

                appDelegate.window?.rootViewController = tabBarController
            }
        }
        alertController.addAction(okAction)

        self.present(alertController, animated: true, completion: nil)

    }

    var recievedCaca = [Caca]()
    var indexPath = IndexPath()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()

        if self.recievedCaca[0].photo != "" {

            DispatchQueue.global().async {
                if let url = URL(string: self.recievedCaca[0].photo) {

                    do {
                        let data = try Data(contentsOf: url)
                        let image = UIImage(data: data)

                        DispatchQueue.main.async {

                            self.cacaPhoto.image = image
                            self.cacaPhoto.layer.cornerRadius = self.cacaPhoto.frame.width / 2
                            self.cacaPhoto.layer.masksToBounds = true
                        }

                    } catch {

                        print(error.localizedDescription)

                    }
                }
            }
        }

        if self.recievedCaca[0].grading == true {

            self.passOrFailLabel.text = "Pass"
            self.passOrFailLabel.backgroundColor = Palette.passColor

        } else {

            self.passOrFailLabel.text = "Fail"
            self.passOrFailLabel.backgroundColor = Palette.failColor

        }

    }

    // MARK: Set Up

    private func setUp() {

        self.view.backgroundColor = Palette.lightblue2

        self.navigationItem.title = "My caca"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Palette.darkblue, NSFontAttributeName: UIFont(name: "Futura-Bold", size: 20) ?? ""]

        self.cacaPhoto.backgroundColor = Palette.lightblue2
        self.shapeImageView.backgroundColor = Palette.lightblue2
        self.colorImageView.backgroundColor = Palette.lightblue2

        self.cacaPhoto.image = #imageLiteral(resourceName: "caca-big")

        self.deleteRecordButton.setTitle("", for: .normal)
        self.deleteRecordButton.setImage(#imageLiteral(resourceName: "trash").withRenderingMode(.alwaysTemplate), for: .normal)
        self.deleteRecordButton.tintColor = Palette.darkblue

        self.dateLabel.text = self.recievedCaca[0].date
        self.timeLabel.text = self.recievedCaca[0].time
        self.consumingTimeLabel.text = self.recievedCaca[0].consumingTime
        self.shapeLabel.text = self.recievedCaca[0].shape
        self.colorLabel.text = self.recievedCaca[0].color
        self.shapeImageView.image = titleToImage(title: self.recievedCaca[0].shape)
        self.colorImageView.image = titleToImage(title: self.recievedCaca[0].color)
        self.amountLabel.text = String(self.recievedCaca[0].amount)
        self.otherInfoLabel.text = self.recievedCaca[0].otherInfo
        self.amountLabel.text = self.recievedCaca[0].amount

        self.passOrFailLabel.textColor = Palette.cream

        let editButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(editCaca))
        self.navigationItem.rightBarButtonItem = editButton

    }

    func editCaca() {

        let fillinStorybard = UIStoryboard(name: "Fillin", bundle: nil)
        guard let fillinTableViewController = fillinStorybard.instantiateViewController(withIdentifier: "FillinTableViewController") as? FillinTableViewController else { return }

        fillinTableViewController.recievedCacaFromRecordDetail = self.recievedCaca
        fillinTableViewController.isFromRecordDetail = true

        present(fillinTableViewController, animated: true)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.isHidden = true

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        tabBarController?.tabBar.isHidden = false

    }
    
    func titleToImage(title: String) -> UIImage {
    
        switch title {
        
        case Color.red.title: return Color.red.image
        case Color.yellow.title: return Color.yellow.image
        case Color.green.title: return Color.green.image
        case Color.lightBrown.title: return Color.lightBrown.image
        case Color.darkBrown.title: return Color.darkBrown.image
        case Color.gray.title: return Color.gray.image
        case Color.black.title: return Color.black.image
            
        case Shape.separateHard.title: return Shape.separateHard.image
        case Shape.lumpySausage.title: return Shape.lumpySausage.image
        case Shape.crackSausage.title: return Shape.crackSausage.image
        case Shape.smoothSausage.title: return Shape.smoothSausage.image
        case Shape.softBlob.title: return Shape.softBlob.image
        case Shape.mushyStool.title: return Shape.mushyStool.image
        case Shape.wateryStool.title: return Shape.wateryStool.image
            
        default: break
        
        }
        
        return #imageLiteral(resourceName: "caca-small")
    }
}
