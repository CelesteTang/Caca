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

    @IBOutlet weak var colorImageView: UIImageView!

    @IBOutlet weak var amountLabel: UILabel!

    @IBOutlet weak var otherInfoLabel: UILabel!

    @IBOutlet weak var passOrFailLabel: UILabel!

    @IBAction func deleteRecord(_ sender: UIButton) {

//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as? TabBarController {
//            
//            tabBarController.selectedIndex = 1
//            
//            let recordTableViewController  = tabBarController.viewControllers?[1] as? RecordTableViewController
//            
//            recordTableViewController?.tableView.deleteRows(at: [indexPath], with: .fade)
//
//            
//            appDelegate.window?.rootViewController = tabBarController
//        }

//        let storyBoard = UIStoryboard(name: "TabBar", bundle: nil)
//
//        guard let tabBarController = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as? TabBarController else {
//
//            return
//        }
//
//        tabBarController.selectedIndex = 1
//
//        guard let recordNavigationController = tabBarController.viewControllers?[1] as? RecordNavigationController else {
//
//            return
//
//        }
//        guard let recordTableViewController = recordNavigationController.viewControllers[0] as? RecordTableViewController else {
//            return
//        }
//
//        recordTableViewController.tableView.deleteRows(at: [indexPath], with: .fade)
//
//        self.navigationController?.pushViewController(recordTableViewController, animated: true)

    }

    var recievedCaca = [Caca]()
    var indexPath = IndexPath()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Palette.backgoundColor

        cacaPhoto.backgroundColor = Palette.backgoundColor
        shapeImageView.backgroundColor = Palette.backgoundColor
        colorImageView.backgroundColor = Palette.backgoundColor

        if recievedCaca[0].photo != "" {

            DispatchQueue.global().async {
                if let url = URL(string: self.recievedCaca[0].photo) {

                    do {
                        let data = try Data(contentsOf: url)
                        let image = UIImage(data: data)
                        
                        DispatchQueue.main.async {
                            self.cacaPhoto.image = image
                        }

                    } catch {

                        print(error)

                    }
                }
            }
        } else {

            cacaPhoto.image = #imageLiteral(resourceName: "poo-icon")

        }

        deleteRecordButton.setTitle("Delete", for: .normal)
        dateLabel.text = recievedCaca[0].date
        timeLabel.text = recievedCaca[0].time
        consumingTimeLabel.text = recievedCaca[0].consumingTime
        shapeImageView.image = recievedCaca[0].shape.image
        colorImageView.image = recievedCaca[0].color.image
        amountLabel.text = String(recievedCaca[0].amount)
        otherInfoLabel.text = recievedCaca[0].otherInfo

        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
        
    }
}
