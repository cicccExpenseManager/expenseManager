import UIKit
import FSCalendar

class ListUpRecordsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance, UIGestureRecognizerDelegate {
    
    // for Navigation Bar
    @IBAction func todayButtonAction(_ sender: UIBarButtonItem) {
        calendar.select(Date())
    }
    
    // for FSCalendar view
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!

    // for segmentedController
    @IBOutlet weak var modeToggle: UISegmentedControl!
    @IBAction func modeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: // SCOPE_MONTHLY
            self.calendar.setScope(.month, animated: true)
        case 1: // SCOPE_WEEKLY
            self.calendar.setScope(.week, animated: true)
        default:
            break;
        }
    }

    // for data table
    @IBOutlet weak var tableView: UITableView!
    fileprivate var expenses: Array<Expense> = []
    fileprivate let dateFormatter: DateFormatter = {
        return DateFormatter().applyRet {$0.dateFormat = "yyyy/MM/dd"}}()
    fileprivate let dateFormatter2: DateFormatter = {
        return DateFormatter().applyRet {$0.dateFormat = "yyyy-MM-dd"}}()

    // for gesture event
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        // put this to avoid retaion cycle
        [unowned self] in
        // implement function
        return UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:))).applyRet {
            $0.delegate = self
            $0.minimumNumberOfTouches = 1
            $0.maximumNumberOfTouches = 2
        }
    }()
    
    // for others
    fileprivate var lastScope: UInt = 0
}

/**---------------------------------------------------------------
 * Override methods
 * --------------------------------------------------------------- */
extension ListUpRecordsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeData()
        initializeView()
    }
}

/**---------------------------------------------------------------
 * Initializer
 * --------------------------------------------------------------- */
extension ListUpRecordsViewController {
    func initializeData() {
        let expenseDao = ExpenseDao()
        expenses = Array(expenseDao.findAllExpenses())
    }
    
    func initializeView() {
        // Note : All delegates are set in view controller

        // set calendar height if the device is iPad
        if UIDevice.current.model.hasPrefix("iPad") {
            self.calendarHeightConstraint.constant = 400
        }

        // set up calendar
        self.calendar.apply {
            // set gesture recognizer to table view
            $0.addGestureRecognizer(self.scopeGesture)
            
            // select today to calendar
            $0.select(Date())
            
            // set calendar mode for default
            $0.scope = .month
        }
    }
}

/**---------------------------------------------------------------
 * Implementation methods for UISegmentedControl
 * --------------------------------------------------------------- */
extension ListUpRecordsViewController {
    func updateSegment() {
        modeToggle.selectedSegmentIndex = Int(calendar.scope.rawValue)
        lastScope = calendar.scope.rawValue
    }
}

/**---------------------------------------------------------------
 * Implementation methods for FSCalendar
 * --------------------------------------------------------------- */
extension ListUpRecordsViewController {
    // getCount for event per day cell
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        print("calendar event count")
//        let dateString = self.dateFormatter2.string(from: date)
        return 2
    }
    
    // getView for event color per day cell
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        print("calendar color unselected")
//        let key = self.dateFormatter2.string(from: date)
        return [UIColor.red, appearance.eventDefaultColor]
    }
    
    // getView for event selected color per day cell
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        print("calendar color selected")
        //        let key = self.dateFormatter2.string(from: date)
        return [UIColor.red, appearance.eventDefaultColor]
    }

    // onClick event when the user touched
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }

    // onChanged event when the user change week or month by swipe
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        updateTable()
    }
    
    // onChanged event when the calendar has changed the own height
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        // Adjust (shrink or make longer) the height
        self.calendarHeightConstraint.constant = bounds.height
        // Render
        self.view.layoutIfNeeded()
        // set segment and table if needed
        if (calendar.scope.rawValue != lastScope) {
            updateSegment()
            updateTable()
        }
    }
}

/**---------------------------------------------------------------
 * Implementation methods for table view
 * --------------------------------------------------------------- */
extension ListUpRecordsViewController {
    // getView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO recycle
        if let tableCell = tableView.cellForRow(at: indexPath) {
            print("recycle \(indexPath.row)")
            return tableCell

        } else {
            print("new \(indexPath.row)")
            let newTableCell = UITableViewCell(style: .default, reuseIdentifier: "row")
            let expense = expenses[indexPath.row]
            newTableCell.textLabel?.text = "\(expense.id) / \(expense.formatDate()) / \(expense.type?.name ?? "none")"
            return newTableCell
        }
    }
    
    // getCount
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    // when you tap the cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let scope: FSCalendarScope = (indexPath.row == 0) ? .month : .week
            self.calendar.setScope(scope, animated: true)
        }
    }
    
    func updateTable() {
        // update table data
        let expenseDao = ExpenseDao()
        switch calendar.scope {
        case .month:
            expenses = Array(expenseDao.findForMonth(date: calendar.currentPage))
        case .week:
            expenses = Array(expenseDao.findForWeek(date: calendar.currentPage))
        }
        
        // Render table again
        tableView.reloadData()
    }
}

/**---------------------------------------------------------------
 * Implementation methods for gesture event
 * --------------------------------------------------------------- */
extension ListUpRecordsViewController {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)

            self.lastScope = calendar.scope.rawValue
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
}
