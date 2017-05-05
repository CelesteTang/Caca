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

    static let shared = CacaProvider()

    func saveCaca2(caca: Caca, uid: String) {

        let value: [String : Any] = [
                     Constants.FirebaseCacaKey.host: uid,
                     Constants.FirebaseCacaKey.cacaID: caca.cacaID,
                     Constants.FirebaseCacaKey.date: caca.date,
                     Constants.FirebaseCacaKey.time: caca.time,
                     Constants.FirebaseCacaKey.consumingTime: caca.consumingTime,
                     Constants.FirebaseCacaKey.shape: caca.shape,
                     Constants.FirebaseCacaKey.color: caca.color,
                     Constants.FirebaseCacaKey.amount: caca.amount,
                     Constants.FirebaseCacaKey.other: caca.otherInfo,
                     Constants.FirebaseCacaKey.grading: caca.grading,
                     Constants.FirebaseCacaKey.advice: caca.advice,
                     Constants.FirebaseCacaKey.period: caca.period,
                     Constants.FirebaseCacaKey.medicine: caca.medicine]

        FIRDatabase.database().reference().child(Constants.FirebaseCacaKey.cacas).child(caca.cacaID).updateChildValues(value) { (error, _) in

            if error != nil {

                print(error?.localizedDescription ?? "")

                return
            }
        }
    }

    func saveCaca(caca: Caca, uid: String) {

        let value: [String : Any] = [Constants.FirebaseCacaKey.host: uid,
                     Constants.FirebaseCacaKey.cacaID: caca.cacaID,
                     Constants.FirebaseCacaKey.photoID: caca.photoID,
                     Constants.FirebaseCacaKey.photoURL: caca.photoURL,
                     Constants.FirebaseCacaKey.date: caca.date,
                     Constants.FirebaseCacaKey.time: caca.time,
                     Constants.FirebaseCacaKey.consumingTime: caca.consumingTime,
                     Constants.FirebaseCacaKey.shape: caca.shape,
                     Constants.FirebaseCacaKey.color: caca.color,
                     Constants.FirebaseCacaKey.amount: caca.amount,
                     Constants.FirebaseCacaKey.other: caca.otherInfo,
                     Constants.FirebaseCacaKey.grading: caca.grading,
                     Constants.FirebaseCacaKey.advice: caca.advice,
                     Constants.FirebaseCacaKey.period: caca.period,
                     Constants.FirebaseCacaKey.medicine: caca.medicine]

        FIRDatabase.database().reference().child(Constants.FirebaseCacaKey.cacas).child(caca.cacaID).updateChildValues(value, withCompletionBlock: { (error, _) in

            if error != nil {

                print(error?.localizedDescription ?? "")

                return
            }

        })
    }

    typealias CacaPhotoHadler = (String?, Error?) -> Void

    func saveCacaPhoto(image: UIImage, photoID: String, completion: @escaping CacaPhotoHadler) {

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

    typealias CacaHadler = ([Caca]?, Error?) -> Void

    func getCaca(completion: @escaping CacaHadler) {

        var cacas = [Caca]()

        FIRDatabase.database().reference().child(Constants.FirebaseCacaKey.cacas)
                                          .queryOrdered(byChild: Constants.FirebaseCacaKey.host)
                                          .queryEqual(toValue: FIRAuth.auth()?.currentUser?.uid)
                                          .observeSingleEvent(of: .value, with: { (snapshot) in

            if let snaps = snapshot.children.allObjects as? [FIRDataSnapshot] {

                for snap in snaps {

                    if let cacaInfo = snap.value as? NSDictionary,
                        let cacaID = cacaInfo[Constants.FirebaseCacaKey.cacaID] as? String,
                        let cacaPhotoURL = cacaInfo[Constants.FirebaseCacaKey.photoURL] as? String?,
                        let cacaPhotoID = cacaInfo[Constants.FirebaseCacaKey.photoID] as? String?,
                        let cacaDate = cacaInfo[Constants.FirebaseCacaKey.date] as? String,
                        let cacaTime = cacaInfo[Constants.FirebaseCacaKey.time] as? String,
                        let cacaConsumingTime = cacaInfo[Constants.FirebaseCacaKey.consumingTime] as? String,
                        let cacaShape = cacaInfo[Constants.FirebaseCacaKey.shape] as? String,
                        let cacaColor = cacaInfo[Constants.FirebaseCacaKey.color] as? String,
                        let cacaAmount = cacaInfo[Constants.FirebaseCacaKey.amount] as? String,
                        let cacaOther = cacaInfo[Constants.FirebaseCacaKey.other] as? String?,
                        let cacaGrading = cacaInfo[Constants.FirebaseCacaKey.grading] as? Bool,
                        let cacaAdvice = cacaInfo[Constants.FirebaseCacaKey.advice] as? String,
                        let period = cacaInfo[Constants.FirebaseCacaKey.period] as? Int?,
                        let medicine = cacaInfo[Constants.FirebaseCacaKey.medicine] as? String? {

                        let caca = Caca(cacaID: cacaID, photoURL: cacaPhotoURL, photoID: cacaPhotoID, date: cacaDate, time: cacaTime, consumingTime: cacaConsumingTime, shape: cacaShape, color: cacaColor, amount: cacaAmount, otherInfo: cacaOther, grading: cacaGrading, advice: cacaAdvice, period: period, medicine: medicine)

                        cacas.append(caca)
                    }
                }
            }

            completion(cacas, nil)

        }) { (error) in

            completion(nil, error)

        }
    }

    typealias EditCacaPhotoHadler = (String?, Error?, Error?) -> Void

    func editCacaPhoto(image: UIImage, photoID: String, completion: @escaping EditCacaPhotoHadler) {

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

                print(error?.localizedDescription ?? "")

                completion(nil, nil, error)
            }

        }

    }

    func deleteCaca(cacaID: String) {

        FIRDatabase.database().reference().child(Constants.FirebaseCacaKey.cacas).child(cacaID).removeValue { (error, _) in

            if error != nil {

                print(error?.localizedDescription ?? "")

            }
        }

    }

    func deleteCacaPhoto(photoID: String) {

        guard let hostUID = FIRAuth.auth()?.currentUser?.uid else { return }
        let storageRef = FIRStorage.storage().reference().child(hostUID).child("\(photoID).jpg")

        storageRef.delete { (error) in

            if error != nil {

                print(error?.localizedDescription ?? "")

            }

        }

    }

}
