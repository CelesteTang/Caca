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

        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.registerCellViewXib(file: "CalendarCellView")
        calendarView.cellInset = CGPoint(x: 0, y: 0)

        calendarView.scrollToDate(Date()) {

            let visibleDates = self.calendarView.visibleDates()
            self.monthChanged(visibleDates)

        }

        adviceView.backgroundColor = Palette.backgoundColor
        adviceLabel.textColor = Palette.textColor

        let provider = CacaProvider.shared

        provider.getCaca { (cacas, _) in

            if let cacas = cacas {
                self.cacas = cacas
            }

            self.calendarView.reloadData()
        }

        let manager = AdviceManager.shared

        manager.getAdvice { (advice) in

            if let advice = advice {

                print(advice.count)
//                self.adviceLabel.text = advice[0]

            }
        }

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

        calendarCell.dayLabel.text = cellState.text
        calendarCell.bottomLine.backgroundColor = Palette.textColor

        if cellState.dateBelongsTo == .thisMonth {

            calendarCell.isUserInteractionEnabled = true
            calendarCell.dayLabel.textColor = Palette.textColor

        } else {

            calendarCell.isUserInteractionEnabled = false
            calendarCell.dayLabel.textColor = UIColor.lightGray

        }

        let currentDateString = dateFormatter.string(from: Date())
        let cellStateDateString = dateFormatter.string(from: cellState.date)

        if  currentDateString ==  cellStateDateString {

            calendarCell.backgroundColor = Palette.todayColor

        } else {

            calendarCell.backgroundColor = Palette.backgoundColor

        }

        calendarCell.selectedView.isHidden = true

        for caca in cacas {

            if caca.date == cellStateDateString {

                if caca.grading == true {
                    calendarCell.selectedView.layer.backgroundColor = Palette.passColor.cgColor
                } else {
                    calendarCell.selectedView.layer.backgroundColor = Palette.failColor.cgColor
                }
                calendarCell.selectedView.layer.cornerRadius = calendarCell.selectedView.frame.width / 2
                calendarCell.selectedView.isHidden = false

            }

        }

//        handleCellTextColor(view: cell, cellState: cellState)
//        handleCellSelection(view: cell, cellState: cellState)
    }

//    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
//
//        handleCellTextColor(view: cell, cellState: cellState)
//        handleCellSelection(view: cell, cellState: cellState)
//
//    }
//
//    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
//
//        handleCellTextColor(view: cell, cellState: cellState)
//        handleCellSelection(view: cell, cellState: cellState)
//    }

//    // Function to handle the text color of the calendar
//    func handleCellTextColor(view: JTAppleDayCellView?, cellState: CellState) {
//
//        guard let calendarCell = view as? CalendarCellView  else { return }
//
//        if cellState.isSelected {
//
//            calendarCell.dayLabel.textColor = Palette.textColor
//
//        } else {
//
//            if cellState.dateBelongsTo == .thisMonth {
//
//                calendarCell.dayLabel.textColor = Palette.textColor
//
//            } else {
//
//                calendarCell.dayLabel.textColor = UIColor.lightGray
//
//            }
//        }
//    }
//
//    // Function to handle the calendar selection
//    func handleCellSelection(view: JTAppleDayCellView?, cellState: CellState) {
//
//        guard let calendarCell = view as? CalendarCellView else { return }
//
//        if cellState.isSelected {
//
//            calendarCell.selectedView.layer.backgroundColor = Palette.textColor.cgColor
//            calendarCell.selectedView.layer.cornerRadius = calendarCell.selectedView.frame.width / 2
//            calendarCell.selectedView.isHidden = false
//
//        } else {
//
//            calendarCell.selectedView.isHidden = true
//
//        }
//    }

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
