//
//  CacaProvider.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/29.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import Foundation
import Firebase

class CacaProvider {

    // MARK: Property

    static let shared = CacaProvider()

//    private var cacas = [Caca]()

    typealias CacaHadler = ([Caca]?, Error?) -> Void

    func getCaca(completion: @escaping CacaHadler) {

        var cacas = [Caca]()

        let rootRef = FIRDatabase.database().reference()

        rootRef.child("cacas").queryOrdered(byChild: "host").queryEqual(toValue: FIRAuth.auth()?.currentUser?.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snaps = snapshot.children.allObjects as? [FIRDataSnapshot] {

                for snap in snaps {

                    if let cacaInfo = snap.value as? NSDictionary,
                        let cacaPhoto = cacaInfo["photo"] as? String,
                        let cacaDate = cacaInfo["date"] as? String,
                        let cacaTime = cacaInfo["consumingTime"] as? String,
                        let cacaShape = cacaInfo["shape"] as? Int,
                        let cacaColor = cacaInfo["color"] as? Int,
                        let cacaAmount = cacaInfo["amount"] as? Double,
                        let cacaOther = cacaInfo["other"] as? String {

                        let caca = Caca(photo: cacaPhoto, date: cacaDate, consumingTime: cacaTime, shape: Shape(rawValue: cacaShape)!, color: Color(rawValue: cacaColor)!, amount: cacaAmount, otherInfo: cacaOther)

                        cacas.append(caca)
                    }
                }
            }

            completion(cacas, nil)
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }

        }) { (error) in

            completion(nil, error)

        }
    }

}
