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

    var advice = String()

    var frequencyAdvice = String()

    var shapeAdvice = String()

    var colorAdvice = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()

        self.calendarView.scrollingMode = .stopAtEachCalendarFrameWidth
        self.automaticallyAdjustsScrollViewInsets = false

        self.calendarView.dataSource = self
        self.calendarView.delegate = self
        self.calendarView.registerCellViewXib(file: "CalendarCellView")
        self.calendarView.cellInset = CGPoint(x: 0, y: 0)

        self.calendarView.scrollToDate(Date()) {

            let visibleDates = self.calendarView.visibleDates()
            self.monthChanged(visibleDates)

        }

        CacaProvider.shared.getCaca { (cacas, _) in

            if let cacas = cacas {
                self.cacas = cacas
            }

            self.calendarView.reloadData()
        }

    }

    // MARK: Set Up

    private func setUp() {

        self.view.backgroundColor = Palette.lightblue2

        self.navigationItem.title = "Calendar"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Palette.darkblue, NSFontAttributeName: UIFont(name: "Futura-Bold", size: 20) ?? ""]

        self.headerView.backgroundColor = Palette.darkblue
        self.headerTitleLabel.textColor = Palette.lightblue2
        self.headerTitleLabel.font = UIFont(name: "Futura-Bold", size: 20)
        self.adviceView.backgroundColor = Palette.lightblue2

        self.adviceLabel.textColor = Palette.darkblue
        self.adviceLabel.text = "How's today?"
        self.adviceLabel.numberOfLines = 0
        self.adviceLabel.font = UIFont(name: "Futura-Bold", size: 20)

    }

    func monthChanged(_ visibleDates: DateSegmentInfo) {

        guard let startDate = visibleDates.monthDates.first else { return }

        let month = Calendar.current.component(.month, from: startDate)
        let year = Calendar.current.component(.year, from: startDate)

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

        calendarCell.backgroundColor = Palette.lightblue2
        calendarCell.dayLabel.text = cellState.text
        calendarCell.dayLabel.font = UIFont(name: "Futura-Bold", size: 20)
        calendarCell.bottomLine.backgroundColor = Palette.darkblue
        calendarCell.didCacaView.isHidden = true
        calendarCell.selectedView.isHidden = true

        let currentDateString = dateFormatter.string(from: Date())
        let cellStateDateString = dateFormatter.string(from: cellState.date)

        if cellState.dateBelongsTo != .thisMonth {

            calendarCell.isUserInteractionEnabled = false
            calendarCell.dayLabel.textColor = UIColor.lightGray

        } else if currentDateString != cellStateDateString {

            calendarCell.isUserInteractionEnabled = true
            calendarCell.dayLabel.backgroundColor = UIColor.clear
            calendarCell.dayLabel.textColor = Palette.darkblue

        } else {

            calendarCell.isUserInteractionEnabled = true
            calendarCell.dayLabel.backgroundColor = Palette.darkblue
            calendarCell.dayLabel.textColor = Palette.lightblue2

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

        handleCellSelection(view: cell, cellState: cellState)

    }

    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {

        handleCellSelection(view: cell, cellState: cellState)

    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {

        handleCellSelection(view: cell, cellState: cellState)

    }

    func handleCellSelection(view: JTAppleDayCellView?, cellState: CellState) {

        guard let calendarCell = view as? CalendarCellView else { return }
        let cellStateDateString = dateFormatter.string(from: cellState.date)

        if cellState.isSelected {

            calendarCell.selectedView.isHidden = false
            calendarCell.selectedView.backgroundColor = Palette.selectedColor

            if calendarCell.didCacaView.isHidden == false {

                for caca in cacas {

                    if caca.date == cellStateDateString {

                        adviceLabel.text = caca.advice

                    }
                }

            } else {

                self.adviceLabel.text = "You don't have any caca record."

            }

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
