import UIKit
import FSCalendar
import SwiftDate

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
    fileprivate let cellIdentifer = "ListUpRecordsCell"
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
    
    // for fotter controller
    @IBAction func addExpenseAction(_ sender: Any) {
        //TODO going to add expense
    }
    @IBAction func prevAction(_ sender: Any) {
        let currentDate = calendar.currentPage
        var dateConmonents = DateComponents()
        dateConmonents.year = currentDate.year
        
        let moveTo: Date
        switch calendar.scope {
        case .month:
            dateConmonents.month = (currentDate - 1.month).month
            moveTo = (DateInRegion(components: dateConmonents)?.startOf(component: .month).absoluteDate)!
        case .week:
            dateConmonents.month = currentDate.month
            let tmp = currentDate - 7.day
            dateConmonents.month = tmp.month
            dateConmonents.day = tmp.day
            moveTo = (DateInRegion(components: dateConmonents)?.startWeek.absoluteDate)!
        }
        
        calendar.select(moveTo)
    }
    @IBAction func nextAction(_ sender: Any) {
        let currentDate = calendar.currentPage
        var dateConmonents = DateComponents()
        dateConmonents.year = currentDate.year
        
        let moveTo: Date
        switch calendar.scope {
        case .month:
            dateConmonents.month = (currentDate + 1.month).month
            moveTo = (DateInRegion(components: dateConmonents)?.startOf(component: .month).absoluteDate)!
        case .week:
            dateConmonents.month = currentDate.month
            let tmp = currentDate + 7.day
            dateConmonents.month = tmp.month
            dateConmonents.day = tmp.day
            moveTo = (DateInRegion(components: dateConmonents)?.startWeek.absoluteDate)!
        }
        
        calendar.select(moveTo)
    }
    
    
    // for others
    fileprivate var lastScope: UInt = 0
    fileprivate var lastSelected: Date = Date()
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
    fileprivate func initializeData() {
        let expenseDao = ExpenseDao()
        expenses = Array(expenseDao.findForMonth(date: Date()))
    }
    
    fileprivate func initializeView() {
        // Note : All delegates are set in view controller
        self.navigationController!.navigationBar.apply {
            // Status bar white font
            $0.barStyle = UIBarStyle.black
            $0.tintColor = UIColor.white

            // Navigation bar to alpha zero
            $0.setBackgroundImage(UIImage(), for: .default)
            $0.shadowImage = UIImage()
        }

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
            
            // disable border of top and bottom
            $0.clipsToBounds = true
        }
    }
}

/**---------------------------------------------------------------
 * Implementation methods for UISegmentedControl
 * --------------------------------------------------------------- */
extension ListUpRecordsViewController {
    fileprivate func updateSegment() {
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
        return ExpenseDao().findForDay(date: date).count
    }
    
    // getView for event color per day cell
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return generateColorArrayForDay(date: date)
    }
    
    // getView for event selected color per day cell
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventSelectionColorsFor date: Date) -> [UIColor]? {
        return generateColorArrayForDay(date: date)
    }
    
    private func generateColorArrayForDay(date: Date) -> [UIColor]? {
        let result = Array(ExpenseDao().findForDay(date: date))
        if (result.isEmpty) {
            return nil
        }
        
        var retColor: Array<UIColor> = []
        for expense in result {
            retColor.append((expense.type?.getColor())!)
        }
        return retColor
    }
    
    private func tableScrollTo(_ date: Date) {
        // ignore if the date is out of month in calendar
        if (date.month != calendar.currentPage.month) {
            return
        }
        
        // ignore if the date expense is empty
        if (ExpenseDao().findForDay(date: date).isEmpty) {
            return
        }

        // find out scroll index
        var scrollTo = 0
        for expense in expenses {
            if (date.day <= (expense.date as Date).day) {
                break
            }
            scrollTo += 1
        }
        
        if scrollTo >= expenses.count {
            // scroll to end as fail safe
            let lastIndexPath = NSIndexPath(row: expenses.count - 1, section: 0) as IndexPath
            tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
            return
        }

        // scroll to the date index
        let indexPath = NSIndexPath(row: scrollTo, section: 0) as IndexPath
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }

    // onClick event when the user touched
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if (date == lastSelected) {
            let storyboard = UIStoryboard(name: "ListUpDailyReports", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ListUpDailyReportsViewController") as! ListUpDailyReportsViewController
            vc.initialize(date: date)
            self.navigationController!.pushViewController(vc, animated: true)

        } else {
            if (calendar.scope == .month) {
                if (calendar.currentPage.month == date.month) {
                    tableScrollTo(date)
                } else {
                    calendar.select(date)
                }
            } else {
                tableScrollTo(date)
            }
        }
        
        lastSelected = date
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
        return (tableView.dequeueReusableCell(
            withIdentifier: cellIdentifer,
            for: indexPath) as! ListUpRecordsCell).applyRet { $0.setExpense(expenses[indexPath.row]) }
    }
    
    // getCount
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    // when you tap the cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        calendar.select(expenses[indexPath.row].date as Date)
    }
    
    fileprivate func updateTable() {
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
