//
//  AdviceManager.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/12.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import Foundation

class AdviceManager {

    // MARK: Property

    static let shared = AdviceManager()

//    var cacas = [Caca]()

    var advice = String()
    
    var frequencyAdvice = String()

    var shapeAdvice = String()
    
    var colorAdvice = String()

    typealias AdviceHadler = (String?, String?, String?, String?) -> Void

    func getAdvice(completion: @escaping AdviceHadler) {

        let provider = CacaProvider.shared

        provider.getCaca { (cacas, _) in

            if let cacas = cacas {

                for caca in cacas {

                    if caca.grading == true {

                        self.advice = "Good caca! Please keep it up!"

                    } else {
                    
                        switch caca.shape {
                            
                        case .separateHard, .lumpySausage:
                            
                            self.shapeAdvice = "You are constipated."
                            
                        case .crackSausage, .smoothSausage: break
                            
                        case .softBlob, .mushyStool, .wateryStool:
                            
                            self.shapeAdvice = "You have diarrhea."
                            
                        }
                        
                        switch caca.color {
                            
                        case .red:
                            
                            self.colorAdvice = "red"
                            
                        case .yellow:
                            
                            self.colorAdvice = "yellow"
                            
                        case .green:
                            
                            self.colorAdvice = "green"
                            
                        case .lightBrown, .darkBrown: break
                            
                        case .gray:
                            
                            self.colorAdvice = "gray"
                            
                        case .black:
                            
                            self.colorAdvice = "black"
                            
                        }
                    
                    }
                    
//                    if (caca.color == Color.lightBrown || caca.color == Color.darkBrown) && (caca.shape == Shape.crackSausage || caca.shape == Shape.smoothSausage) {
//                        
//                        self.advice = "Good caca! Please keep it up!"
//
//                    }

                }

                completion(self.advice, self.frequencyAdvice, self.shapeAdvice, self.colorAdvice)
            }
        }

    }

}
