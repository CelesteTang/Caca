//
//  UserManager.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/22.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import Foundation
import Firebase

class UserManager {

    // MARK: Property

    static let shared = UserManager()

    // MARK: Create user

    typealias CreateHadler = (Error?, Error?) -> Void

    func createUser(with email: String, password: String, name: String, gender: Int, completion: @escaping CreateHadler) {

        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in

            if let error = error {

                completion(error, nil)

            } else {

                let value = ["name": name,
                             "gender": gender] as [String: Any]

                if let user = user {

                    let uid = user.uid

                    FIRDatabase.database().reference().child("users").child(uid).updateChildValues(value, withCompletionBlock: { (error, _) in

                        if let error = error {

                            completion(nil, error)

                        } else {

                            completion(nil, nil)
                        }

                    })
                }
            }
        })
    }

    // MARK: Create user anonymously

    typealias AnonymouslyCreateHadler = (Error?, Error?) -> Void

    func createAnonymousUser(completion: @escaping AnonymouslyCreateHadler) {

        FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in

            if let error = error {

                completion(error, nil)

            } else {

                let value = ["name": "",
                             "gender": ""] as [String: Any]

                if let user = user {

                    let uid = user.uid

                    FIRDatabase.database().reference().child("users").child(uid).updateChildValues(value, withCompletionBlock: { (error, _) in

                        if let error = error {

                            completion(nil, error)

                        } else {

                            completion(nil, nil)
                        }
                    })
                }
            }
        })
    }

    // MARK: Link anonymous user to permanent account

    typealias LinkHadler = (Error?, Error?) -> Void

    func linkUser(with email: String, password: String, name: String, gender: Int, completion: @escaping LinkHadler) {

        let credential = FIREmailPasswordAuthProvider.credential(withEmail: email, password: password)

        FIRAuth.auth()?.currentUser?.link(with: credential, completion: { (user, error) in

            if let error = error {

                completion(error, nil)

            } else {

                let value = ["name": name,
                             "gender": gender] as [String: Any]

                if let user = user {

                    let uid = user.uid

                    FIRDatabase.database().reference().child("users").child(uid).updateChildValues(value, withCompletionBlock: { (error, _) in

                        if let error = error {

                            completion(nil, error)

                        } else {

                            completion(nil, nil)
                        }
                    })
                }
            }
        })
    }

    // MARK: Edit user

    func editUser(with uid: String, value: [String: Any]) {

        FIRDatabase.database().reference().child("users").child(uid).updateChildValues(value, withCompletionBlock: { (error, _) in

            if error != nil {

                print(error?.localizedDescription ?? "")

                return
            }

        })

    }

}
