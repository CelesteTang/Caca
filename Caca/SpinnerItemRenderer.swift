//
//  SpinnerItemRenderer.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/4/19.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class ColorSpinnerItemRenderer: UIControl {

    let label = UILabel()

    let swatch = UIImageView()

    init(frame: CGRect, color: Color) {
        super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 100))

        label.text = color.title
        label.font = UIFont(name: "Futura-Bold", size: 20)
        label.textColor = color.color
        swatch.image = color.image

        addSubview(label)

        addSubview(swatch)
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }

    override func didMoveToWindow() {
        label.frame = CGRect(x: 20, y: 0, width: 300, height: 100)
        swatch.frame = CGRect(x: 240, y: 80 / 2 - 5, width: 30, height: 30)
    }

}

class ShapeSpinnerItemRenderer: UIControl {

    let label = UILabel()

    let swatch = UIImageView()

    init(frame: CGRect, shape: Shape) {
        super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 200))

        label.text = shape.title
        label.font = UIFont(name: "Futura-Bold", size: 20)
        swatch.image = shape.image

        addSubview(label)

        addSubview(swatch)
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }

    override func didMoveToWindow() {
        label.frame = CGRect(x: 20, y: 0, width: 300, height: 200)
        swatch.frame = CGRect(x: 240, y: 160 / 2 - 15, width: 70, height: 70)
    }

}
