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
import KeychainAccess

class UserManager {

    // MARK: Property

    static let shared = UserManager()

    let keychain = Keychain(service: "tw.hsinyutang.Caca-user")

    // MARK: Crashlytics

    func logUser(email: String? = nil, uid: String) {

        Crashlytics.sharedInstance().setUserEmail(email)
        Crashlytics.sharedInstance().setUserIdentifier(uid)
    }

    // MARK: Create user

    typealias CreateHadler = (Error?, Error?) -> Void

    func createUser(with email: String, password: String, gender: String, medicine: String, completion: @escaping CreateHadler) {

        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in

            if let error = error {

                completion(error, nil)

            } else {

                self.keychain[Constants.KeychainKey.gender] = gender
                self.keychain[Constants.KeychainKey.medicine] = medicine

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

                self.keychain[Constants.KeychainKey.gender] = Gender.male.title
                self.keychain[Constants.KeychainKey.medicine] = Medicine.no.title

                let value = [Constants.FirebaseUserKey.gender: Gender.male.title,
                             Constants.FirebaseUserKey.medicine: Medicine.no.title] as [String: Any]

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

    func linkUser(with email: String, password: String, gender: String, medicine: String, completion: @escaping LinkHadler) {

        let credential = FIREmailPasswordAuthProvider.credential(withEmail: email, password: password)

        FIRAuth.auth()?.currentUser?.link(with: credential, completion: { (user, error) in

            if let error = error {

                completion(error, nil)

            } else {

                self.keychain[Constants.KeychainKey.gender] = gender
                self.keychain[Constants.KeychainKey.medicine] = medicine

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

    typealias SignInHadler = (Error?) -> Void

    func signIn(with email: String, password: String, completion: @escaping SignInHadler) {

        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (_, error) in

            if let error = error {

                completion(error)

            } else {

                completion(nil)

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

                if let userInfo = snapshot.value as? NSDictionary,
                    let userGender = userInfo[Constants.FirebaseUserKey.gender] as? String,
                    let userMedicine = userInfo[Constants.FirebaseUserKey.medicine] as? String {

                    user.gender = userGender
                    user.medicine = userMedicine

                    completion(user, nil)

                }

            }) { (error) in

                completion(nil, error)

        }
    }

    func editUser(value: [String: Any]) {

        if let uid = FIRAuth.auth()?.currentUser?.uid {

            FIRDatabase.database().reference().child(Constants.FirebaseUserKey.users).child(uid).updateChildValues(value, withCompletionBlock: { (error, _) in

                if error != nil {

                    print(error?.localizedDescription ?? "")

                    return
                }

            })
        }
    }

}
