//
//  CalendarViewController.swift
//  Caca
//
//  Created by 湯芯瑜 on 2017/3/20.
//  Copyright © 2017年 Hsin-Yu Tang. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {

    @IBOutlet weak var headerView: UIView!

    @IBOutlet weak var headerTitleLabel: UILabel!

    @IBOutlet weak var calendarView: JTAppleCalendarView!

    @IBOutlet weak var adviceView: UIView!

    @IBOutlet weak var adviceLabel: UILabel!

    let dateFormatter = DateFormatter()

    var cacas = [Caca]()

    override func viewDidLoad() {
        super.viewDidLoad()

        calendarView.scrollingMode = .stopAtEachCalendarFrameWidth
        self.automaticallyAdjustsScrollViewInsets = false

        navigationItem.title = "Calendar"
        view.backgroundColor = Palette.backgoundColor

        headerView.backgroundColor = Palette.textColor
        headerTitleLabel.textColor = Palette.backgoundColor
        adviceView.backgroundColor = Palette.backgoundColor
        adviceLabel.textColor = Palette.textColor

        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.registerCellViewXib(file: "CalendarCellView")
        calendarView.cellInset = CGPoint(x: 0, y: 0)

        calendarView.scrollToDate(Date()) {

            let visibleDates = self.calendarView.visibleDates()
            self.monthChanged(visibleDates)

        }

        let provider = CacaProvider.shared

        provider.getCaca { (cacas, _) in

            if let cacas = cacas {
                self.cacas = cacas
            }

            self.calendarView.reloadData()
        }

//        let manager = AdviceManager.shared
//
//        manager.getAdvice { (advice) in
//
//            if let advice = advice {
//
//                print(advice.count)
//                self.adviceLabel.text = advice[0]
//
//            }
//        }

    }

    func monthChanged(_ visibleDates: DateSegmentInfo) {

        guard let startDate = visibleDates.monthDates.first else {
            return
        }

        let calendar = Calendar.current
        let month = calendar.component(.month, from: startDate)
        let year = calendar.component(.year, from: startDate)

        self.headerTitleLabel.text = String(format: "%04i-%02i", year, month)

    }

}

extension CalendarViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {

        dateFormatter.dateFormat = "yyyy-MM-dd"

        let startDate = dateFormatter.date(from: "2015-01-01")!
        let endDate = dateFormatter.date(from: "2067-12-31")!
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6,
                                                 calendar: Calendar.current,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfGrid,
                                                 firstDayOfWeek: .sunday)
        return parameters
    }

    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {

        guard let calendarCell = cell as? CalendarCellView else { return }

        calendarCell.backgroundColor = Palette.backgoundColor
        calendarCell.dayLabel.text = cellState.text
        calendarCell.bottomLine.backgroundColor = Palette.textColor
        calendarCell.didCacaView.isHidden = true
        calendarCell.selectedView.isHidden = true

        let currentDateString = dateFormatter.string(from: Date())
        let cellStateDateString = dateFormatter.string(from: cellState.date)

        if cellState.dateBelongsTo != .thisMonth {

            calendarCell.isUserInteractionEnabled = false
            calendarCell.dayLabel.textColor = UIColor.lightGray

        } else if currentDateString != cellStateDateString {

            calendarCell.isUserInteractionEnabled = true
            calendarCell.dayLabel.backgroundColor = Palette.backgoundColor
            calendarCell.dayLabel.textColor = Palette.textColor

        } else {

            calendarCell.isUserInteractionEnabled = true
            calendarCell.dayLabel.backgroundColor = Palette.textColor
            calendarCell.dayLabel.textColor = Palette.backgoundColor

        }

        for caca in cacas {

            if caca.date == cellStateDateString {

                if caca.grading == true {

                    calendarCell.didCacaView.backgroundColor = Palette.passColor

                } else {

                    calendarCell.didCacaView.backgroundColor = Palette.failColor

                }

                calendarCell.didCacaView.layer.cornerRadius = calendarCell.didCacaView.frame.width / 2
                calendarCell.didCacaView.isHidden = false

            }

        }

    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {

        handleCellSelection(view: cell, cellState: cellState)

    }

    func handleCellSelection(view: JTAppleDayCellView?, cellState: CellState) {

        guard let calendarCell = view as? CalendarCellView else { return }

        if cellState.isSelected {

            calendarCell.selectedView.isHidden = false
            calendarCell.selectedView.backgroundColor = Palette.passColor
            calendarCell.selectedView.layer.cornerRadius = calendarCell.selectedView.frame.width / 2

        } else {

            calendarCell.selectedView.isHidden = true

        }
    }

    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {

        self.monthChanged(visibleDates)

    }
}

extension CalendarViewController {

    // swiftlint:disable force_cast
    class func create() -> CalendarViewController {

        return UIStoryboard(name: "Calendar", bundle: nil).instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController

    }
    // swiftlint:enable force_cast

}
