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

    // MARK: Save caca

    func saveCaca(cacaID: String, value: [String : Any]) {

        FIRDatabase.database().reference().child("cacas").child(cacaID).updateChildValues(value, withCompletionBlock: { (error, _) in

            if error != nil {

                print(error?.localizedDescription ?? "")

                return
            }

        })
    }

    // MARK: Save caca photo

    typealias CacaPhotoHadler = (String?, Error?) -> Void

    func saveCacaPhoto(of image: UIImage, with photoID: String, completion: @escaping CacaPhotoHadler) {

        guard let hostUID = FIRAuth.auth()?.currentUser?.uid else { return }
        let storageRef = FIRStorage.storage().reference().child(hostUID).child("\(photoID).jpg")

        if let uploadData = UIImageJPEGRepresentation(image, 0.1) {

            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in

                completion(nil, error)

                if let cacaPhotoUrl = metadata?.downloadURL()?.absoluteString {

                    completion(cacaPhotoUrl, nil)
                }
            })
        }

    }

    // MARK: Get caca

    typealias CacaHadler = ([Caca]?, Error?) -> Void

    func getCaca(completion: @escaping CacaHadler) {

        var cacas = [Caca]()

        FIRDatabase.database().reference().child("cacas").queryOrdered(byChild: "host").queryEqual(toValue: FIRAuth.auth()?.currentUser?.uid).observeSingleEvent(of: .value, with: { (snapshot) in

            if let snaps = snapshot.children.allObjects as? [FIRDataSnapshot] {

                for snap in snaps {

                    if let cacaInfo = snap.value as? NSDictionary,
                        let cacaID = cacaInfo["cacaID"] as? String,
                        let cacaPhoto = cacaInfo["photo"] as? String,
                        let cacaPhotoID = cacaInfo["photoID"] as? String,
                        let cacaDate = cacaInfo["date"] as? String,
                        let cacaTime = cacaInfo["time"] as? String,
                        let cacaConsumingTime = cacaInfo["consumingTime"] as? String,
                        let cacaShape = cacaInfo["shape"] as? String,
                        let cacaColor = cacaInfo["color"] as? String,
                        let cacaAmount = cacaInfo["amount"] as? String,
                        let cacaOther = cacaInfo["other"] as? String,
                        let cacaGrading = cacaInfo["grading"] as? Bool,
                        let cacaAdvice = cacaInfo["advice"] as? String {

                        let caca = Caca(cacaID: cacaID, photo: cacaPhoto, photoID: cacaPhotoID, date: cacaDate, time: cacaTime, consumingTime: cacaConsumingTime, shape: cacaShape, color: cacaColor, amount: cacaAmount, otherInfo: cacaOther, grading: cacaGrading, advice: cacaAdvice)

                        cacas.append(caca)
                    }
                }
            }

            completion(cacas, nil)

        }) { (error) in

            completion(nil, error)

        }
    }

    // MARK: Edit caca

    func editCaca(of cacaID: String, value: [String : Any]) {

        FIRDatabase.database().reference().child("cacas").child(cacaID).updateChildValues(value, withCompletionBlock: { (error, _) in

            if error != nil {

                print(error?.localizedDescription ?? "")

                return
            }

        })

    }

    // MARK: Edit caca photo

    typealias EditCacaPhotoHadler = (String?, Error?, Error?) -> Void

    func editCacaPhoto(of image: UIImage, with photoID: String, completion: @escaping EditCacaPhotoHadler) {

        guard let hostUID = FIRAuth.auth()?.currentUser?.uid else { return }
        let storageRef = FIRStorage.storage().reference().child(hostUID).child("\(photoID).jpg")

        storageRef.delete { (error) in

            if error == nil {

                if let uploadData = UIImageJPEGRepresentation(image, 0.1) {

                    storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in

                        completion(nil, error, nil)

                        if let cacaPhotoUrl = metadata?.downloadURL()?.absoluteString {

                            completion(cacaPhotoUrl, nil, nil)
                        }
                    })
                }

            } else {

                print(error?.localizedDescription ?? "--Edit caca photo error--")

                completion(nil, nil, error)
            }

        }

    }

    // MARK: Delete caca

    func deleteCaca(of cacaID: String) {

        FIRDatabase.database().reference().child("cacas").child(cacaID).removeValue { (error, _) in

            if error != nil {

                print(error?.localizedDescription ?? "")

            }
        }

    }

    // MARK: Delete caca photo

    func deleteCacaPhoto(of photoID: String) {

        guard let hostUID = FIRAuth.auth()?.currentUser?.uid else { return }
        let storageRef = FIRStorage.storage().reference().child(hostUID).child("\(photoID).jpg")

        storageRef.delete { (error) in

            if error != nil {

                print(error?.localizedDescription ?? "")

            }

        }

    }

}
