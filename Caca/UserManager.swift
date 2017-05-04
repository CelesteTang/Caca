//
//  UserManager.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/22.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import Foundation
import Firebase
import Crashlytics

class UserManager {

    // MARK: Property

    static let shared = UserManager()

    // MARK: Crashlytics

    func logUser(email: String? = nil, uid: String) {

        Crashlytics.sharedInstance().setUserEmail(email)
        Crashlytics.sharedInstance().setUserIdentifier(uid)
    }

    // MARK: Create user

    typealias CreateHadler = (Error?, Error?) -> Void

    func createUser(with email: String, password: String, gender: Int, medicine: Int, completion: @escaping CreateHadler) {

        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in

            if let error = error {

                completion(error, nil)

            } else {

                let value = [Constants.FirebaseUserKey.gender: gender,
                             Constants.FirebaseUserKey.medicine: medicine] as [String: Any]

                if let user = user {

                    let uid = user.uid

                    FIRDatabase.database().reference().child(Constants.FirebaseUserKey.users).child(uid).updateChildValues(value, withCompletionBlock: { (error, _) in

                        if let error = error {

                            completion(nil, error)

                        } else {

                            self.logUser(email: email, uid: uid)

                            completion(nil, nil)

                        }

                    })
                }
            }
        })
    }

    // MARK: Create user anonymously

    typealias AnonymouslyCreateHadler = (Error?) -> Void

    func createAnonymousUser(completion: @escaping AnonymouslyCreateHadler) {

        FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in

            if let error = error {

                completion(error)

            } else {

                let value = [Constants.FirebaseUserKey.gender: User().gender,
                             Constants.FirebaseUserKey.medicine: User().medicine] as [String: Any]
                
                if let user = user {
                    
                    let uid = user.uid
                    
                    FIRDatabase.database().reference().child(Constants.FirebaseUserKey.users).child(uid).updateChildValues(value, withCompletionBlock: { (error, _) in
                        
                        if let error = error {
                            
                            print(error)
                            
                        } else {
                            
                            self.logUser(uid: uid)
                            
                            completion(nil)
                            
                        }
                    })
                }
            }
        })
    }

    // MARK: Link anonymous user to permanent account

    typealias LinkHadler = (Error?, Error?) -> Void

    func linkUser(with email: String, password: String, gender: Int, medicine: Int, completion: @escaping LinkHadler) {

        let credential = FIREmailPasswordAuthProvider.credential(withEmail: email, password: password)

        FIRAuth.auth()?.currentUser?.link(with: credential, completion: { (user, error) in

            if let error = error {

                completion(error, nil)

            } else {

                let value = [Constants.FirebaseUserKey.gender: gender,
                             Constants.FirebaseUserKey.medicine: medicine] as [String: Any]

                if let user = user {

                    let uid = user.uid

                    FIRDatabase.database().reference().child(Constants.FirebaseUserKey.users).child(uid).updateChildValues(value, withCompletionBlock: { (error, _) in

                        if let error = error {

                            completion(nil, error)

                        } else {

                            self.logUser(email: email, uid: uid)

                            completion(nil, nil)
                        }
                    })
                }
            }
        })
    }

    typealias UserHadler = (User?, Error?) -> Void
    
    func getUser(completion: @escaping UserHadler) {
        
        var user = User()
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
        
        FIRDatabase.database().reference().child(Constants.FirebaseUserKey.users)
            .child(uid)
            .observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let snaps = snapshot.children.allObjects as? [FIRDataSnapshot] {
                    
                    if let userInfo = snaps[0].value as? NSDictionary,
                        let userGender = userInfo[Constants.FirebaseUserKey.gender] as? Int,
                        let userMedicine = userInfo[Constants.FirebaseUserKey.medicine] as? Int {
                        
                        user.gender = userGender
                        user.medicine = userMedicine
                        
                        completion(user, nil)
                        
                    }
                }
                
            }) { (error) in
                
                completion(nil, error)
                
        }
    }
    
    // MARK: Edit user

    func editUser(with uid: String, value: [String: Any]) {

        FIRDatabase.database().reference().child(Constants.FirebaseUserKey.users).child(uid).updateChildValues(value, withCompletionBlock: { (error, _) in

            if error != nil {

                print(error?.localizedDescription ?? "")

                return
            }

        })

    }

}
