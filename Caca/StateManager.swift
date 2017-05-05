//
//  StateManager.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/5/5.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import Foundation

class StateManager {

    static let shared = StateManager()

    var cacas = [Caca]()

    var advice = String()

    var shapeAdvice = String()

    var colorAdvice = String()

    var frequencyAdvice = String()

    var ispassed = false

    func getState(caca: Caca, comparedWith cacas: [Caca]) -> (grading: Bool, advice: String) {

        // MARK: Pass or Fail

        if (caca.color == Color.lightBrown.title || caca.color == Color.darkBrown.title) && (caca.shape == Shape.crackSausage.title || caca.shape == Shape.smoothSausage.title) {

            ispassed = true

            self.advice = NSLocalizedString("Good caca! Please keep it up!", comment: "")

        } else {

            self.advice = NSLocalizedString("Warning! Your caca may not be healthy! ", comment: "")

            // MARK: Shape

            switch caca.shape {

            case Shape.separateHard.title, Shape.lumpySausage.title:

                self.shapeAdvice = NSLocalizedString("You are constipated, and ", comment: "")

            case Shape.crackSausage.title, Shape.smoothSausage.title:

                self.shapeAdvice = NSLocalizedString("The shape of your caca is good, but ", comment: "")

            case Shape.softBlob.title, Shape.mushyStool.title, Shape.wateryStool.title:

                self.shapeAdvice = NSLocalizedString("You have diarrhea, and ", comment: "")

            default: break

            }

            // MARK: Color

            switch caca.color {

            case Color.red.title:

                self.colorAdvice = NSLocalizedString("the color of your caca is red. ", comment: "")

            case Color.yellow.title:

                self.colorAdvice = NSLocalizedString("the color of your caca is yellow. ", comment: "")

            case Color.green.title:

                self.colorAdvice = NSLocalizedString("the color of your caca is green. ", comment: "")

            case Color.lightBrown.title, Color.darkBrown.title:

                self.colorAdvice = NSLocalizedString("the color of your caca is good! ", comment: "")

            case Color.gray.title:

                self.colorAdvice = NSLocalizedString("the color of your caca is gray. ", comment: "")

            case Color.black.title:

                self.colorAdvice = NSLocalizedString("the color of your caca is black. ", comment: "")

            default: break

            }

            // MARK: Continuous Fail

            if cacas.count == 1 {

                if cacas[cacas.count - 1].grading == false && ispassed == false {

                    self.frequencyAdvice = NSLocalizedString("If you have the same symptom tomorrow, you should go to see a doctor.", comment: "")

                }

            } else if cacas.count > 1 {

                if cacas[cacas.count - 2].grading == false && cacas[cacas.count - 1].grading == false && ispassed == false {

                    self.frequencyAdvice = NSLocalizedString("You should go to see a doctor NOW!", comment: "")

                } else if cacas[cacas.count - 1].grading == false && ispassed == false {

                    self.frequencyAdvice = NSLocalizedString("If you have the same symptom tomorrow, you should go to see a doctor.", comment: "")

                }

            }
        }

        let overallAdvice = self.advice + self.shapeAdvice + self.colorAdvice + self.frequencyAdvice

        return (ispassed, overallAdvice)
    }

}
