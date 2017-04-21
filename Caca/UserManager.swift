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

    func createUser(with email: String, password: String) {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if let error = error {
                
                let alertController = UIAlertController(title: "Warning",
                                                        message: error.localizedDescription,
                                                        preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: "OK",
                                                        style: .default,
                                                        handler: nil))
                
                present(alertController, animated: true, completion: nil)
                
                return
                
            } else {
                
                guard let uid = user?.uid else { return }
                
                let userRef = FIRDatabase.database().reference().child("users").child(uid)
                
                guard let name = self.nameField.text else { return }
                
                let gender = self.genderSegmentedControl.selectedSegmentIndex
                
                UserDefaults.standard.set(name, forKey: "Name")
                UserDefaults.standard.set(gender, forKey: "Gender")
                
                let value = ["name": name,
                             "gender": gender] as [String: Any]
                
                userRef.updateChildValues(value, withCompletionBlock: { (error, _) in
                    
                    if error != nil {
                        
                        print(error?.localizedDescription ?? "-SignUp---------Update error")
                        
                        return
                    }
                })
            }
            
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.window?.rootViewController = UIStoryboard(name: "Opening", bundle: nil).instantiateViewController(withIdentifier: "OpeningPageViewController") as? OpeningPageViewController
                
                self.isFromProfile = false
            }
        })
        
    }

}
