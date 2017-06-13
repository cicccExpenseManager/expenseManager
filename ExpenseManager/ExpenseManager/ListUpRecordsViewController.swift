import UIKit
import FSCalendar

class ListUpRecordsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance, UIGestureRecognizerDelegate {
    
    var expenses: Array<Expense> = []
    
    @IBOutlet weak var calendar: FSCalendar!
//    @IBOutlet weak var animationSwitch: UISwitch!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var modeToggle: UISegmentedControl!
    @IBAction func modeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.calendar.setScope(.week, animated: true)
        case 1:
            self.calendar.setScope(.month, animated: true)
        default:
            break;
        }
    }

    @IBOutlet weak var tableView: UITableView!

    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeData()
        initializeView()
    }
    
    deinit {
        print("\(#function)")
    }
    
    // MARK:- UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        print("gestureRecognizerShouldBegin")
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    // MARK:- UITableViewDataSource
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
}

/**
 * Initializer
 */
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

        // select today to calendar
        self.calendar.select(Date())
        print("### aaa")

        // set gesture recognizer to view
        self.view.addGestureRecognizer(self.scopeGesture)

        // set gesture recognizer to table view
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)

        // set calendar mode for default
        self.calendar.scope = .month
        
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
    }
}

/**
 * Implementation methods for FSCalendar
 */
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

    // onChanged event when the user change view mode (Weekly / Monthly)
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
}

/**
 * Implementation methods for table view
 */
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
            newTableCell.textLabel?.text = "\(expense.id) / \(expense.type?.name ?? "none") / \(expense.date.description)"
            return newTableCell
        }
    }
    
    // getCount
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let scope: FSCalendarScope = (indexPath.row == 0) ? .month : .week
            self.calendar.setScope(scope, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}
