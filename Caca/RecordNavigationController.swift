//
//  RecordNavigationController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/20.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class RecordNavigationController: UINavigationController {

    // MARK: Init

    init() {
        super.init(rootViewController: RecordTableViewController())
    }

    private override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)

        setUp()

    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        setUp()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setUp()

    }

    // MARK: Set Up

    private func setUp() {

        viewControllers = [RecordTableViewController()]
        
        self.tabBarItem = TabBarItemType.record.item

    }

}
