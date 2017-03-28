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
    }

}

extension CalendarViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"

        let startDate = formatter.date(from: "2017 03 01")! // You can use date generated from a formatter
        let endDate = Date()                                // You can also use dates created from this function
        let parameters = ConfigurationParameters(startDate: startDate,
                                                 endDate: endDate,
                                                 numberOfRows: 6, // Only 1, 2, 3, & 6 are allowed
                                                 calendar: Calendar.current,
                                                 generateInDates: .forAllMonths,
                                                 generateOutDates: .tillEndOfGrid,
                                                 firstDayOfWeek: .sunday)

        return parameters
    }

    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {

        guard let myCustomCell = cell as? CalendarCellView else { return }

        // Setup Cell text
        myCustomCell.dayLabel.text = cellState.text
        myCustomCell.backgroundColor = Palette.backgoundColor

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

        guard let myCustomCell = view as? CalendarCellView  else { return }

        if cellState.isSelected {

            myCustomCell.dayLabel.textColor = UIColor.blue

        } else {

            if cellState.dateBelongsTo == .thisMonth {

                myCustomCell.dayLabel.textColor = Palette.textColor

            } else {

                myCustomCell.dayLabel.textColor = UIColor.gray

            }
        }
    }

    // Function to handle the calendar selection
    func handleCellSelection(view: JTAppleDayCellView?, cellState: CellState) {

        guard let myCustomCell = view as? CalendarCellView  else { return }

        if cellState.isSelected {

            myCustomCell.selectedView.layer.backgroundColor = UIColor.brown.cgColor
            myCustomCell.selectedView.layer.cornerRadius = 25
            myCustomCell.selectedView.isHidden = false

        } else {

            myCustomCell.selectedView.isHidden = true

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
