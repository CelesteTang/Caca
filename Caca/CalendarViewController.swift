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

    @IBOutlet weak var calendarView: JTAppleCalendarView!

    @IBOutlet weak var adviceView: UIView!

    @IBOutlet weak var adviceLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Calendar"
        view.backgroundColor = Palette.backgoundColor

        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.registerCellViewXib(file: "CalendarCellView")
        calendarView.cellInset = CGPoint(x: 0, y: 0)
        calendarView.scrollingMode = .stopAtEachCalendarFrameWidth
        calendarView.registerHeaderView(xibFileNames: ["HeaderView"])

        self.automaticallyAdjustsScrollViewInsets = false

        adviceView.backgroundColor = Palette.backgoundColor
        adviceLabel.textColor = Palette.textColor
    }

}

extension CalendarViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"

        let startDate = formatter.date(from: "2016 01 01")!
        let endDate = Date()
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6,
                                                 calendar: Calendar.current,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfRow,
                                                 firstDayOfWeek: .sunday)
        return parameters
    }

    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {

        guard let calendarCell = cell as? CalendarCellView else { return }

        // Setup Cell text
        calendarCell.dayLabel.text = cellState.text
        calendarCell.backgroundColor = Palette.backgoundColor
        calendarCell.bottomLine.backgroundColor = Palette.textColor

        if cellState.dateBelongsTo == .thisMonth {

            calendarCell.isUserInteractionEnabled = true

        } else {

            calendarCell.isUserInteractionEnabled = false

        }

        handleCellTextColor(view: cell, cellState: cellState)
        handleCellSelection(view: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {

        handleCellTextColor(view: cell, cellState: cellState)
        handleCellSelection(view: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {

        handleCellTextColor(view: cell, cellState: cellState)
        handleCellSelection(view: cell, cellState: cellState)
    }

    // Function to handle the text color of the calendar
    func handleCellTextColor(view: JTAppleDayCellView?, cellState: CellState) {

        guard let calendarCell = view as? CalendarCellView  else { return }

        if cellState.isSelected {

            calendarCell.dayLabel.textColor = UIColor.blue

        } else {

            if cellState.dateBelongsTo == .thisMonth {

                calendarCell.dayLabel.textColor = Palette.textColor

            } else {

                calendarCell.dayLabel.textColor = UIColor.gray

            }
        }
    }

    // Function to handle the calendar selection
    func handleCellSelection(view: JTAppleDayCellView?, cellState: CellState) {

        guard let calendarCell = view as? CalendarCellView  else { return }

        if cellState.isSelected {

            calendarCell.selectedView.layer.backgroundColor = UIColor.brown.cgColor
            calendarCell.selectedView.layer.cornerRadius = 25
            calendarCell.selectedView.isHidden = false

        } else {

            calendarCell.selectedView.isHidden = true

        }
    }

    // This sets the height of your header
    func calendar(_ calendar: JTAppleCalendarView, sectionHeaderSizeFor range: (start: Date, end: Date), belongingTo month: Int) -> CGSize {
        return CGSize(width: 200, height: 80)
    }

    // This setups the display of your header
    func calendar(_ calendar: JTAppleCalendarView, willDisplaySectionHeader header: JTAppleHeaderView, range: (start: Date, end: Date), identifier: String) {

        let headerCell = (header as? HeaderView)
        headerCell?.titleLabel.text = "Hello Header"
        headerCell?.backgroundColor = Palette.textColor
        headerCell?.titleLabel.textColor = Palette.backgoundColor
    }
}

extension CalendarViewController {

    // swiftlint:disable force_cast
    class func create() -> CalendarViewController {

        return UIStoryboard(name: "Calendar", bundle: nil).instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController

    }
    // swiftlint:enable force_cast

}
