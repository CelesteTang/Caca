//
//  OpeningPageViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/20.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit

class OpeningPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    var pageHeadings = ["Do you remember the last caca time ?", "Do you know caca could reveal your healthy state?", "Let's build up the good habit of caca with Caca!"]

    var pageImages = ["A", "B", "C"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = Palette.lightblue2

        self.dataSource = self

        if let startingViewController = contentViewController(at: 0) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }

    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        // swiftlint:disable force_cast
        var index = (viewController as! OpeningViewController).index
        // swiftlint:enable force_cast
        index += 1

        return contentViewController(at: index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        // swiftlint:disable force_cast
        var index = (viewController as! OpeningViewController).index
        // swiftlint:enable force_cast
        index -= 1

        return contentViewController(at: index)
    }

    func contentViewController(at index: Int) -> OpeningViewController? {

        if index < 0 || index >= pageHeadings.count {
            return nil
        }

        if let pageContentViewController = storyboard?.instantiateViewController(withIdentifier: "OpeningViewController") as? OpeningViewController {
            pageContentViewController.imageFile = pageImages[index]
            pageContentViewController.heading = pageHeadings[index]
            pageContentViewController.index = index

            return pageContentViewController
        }

        return nil
    }

    func forward(index: Int) {
        if let nextViewController = contentViewController(at: index + 1) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
}
