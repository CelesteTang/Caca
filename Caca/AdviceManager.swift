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

    var advice: [String] = []

    typealias AdviceHadler = ([String]?) -> Void

    func getAdvice(completion: @escaping AdviceHadler) {

        let provider = CacaProvider.shared

        provider.getCaca { (cacas, _) in

            if let cacas = cacas {

                for caca in cacas {

                    if caca.color == Color.lightBrown || caca.color == Color.darkBrown {

                        self.advice.append("Color passed")

                    }
                }

                completion(self.advice)
            }
        }

    }

}
