import UIKit
import SwiftDate

class ListUpDailyReportsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // For data table
    fileprivate var date: Date = Date()
    internal var expenses: Array<Expense> = []
    fileprivate let cellIdentifer = "ListUpDailyRecordsCell"
    fileprivate let dateFormatter: DateFormatter = {
        return DateFormatter().applyRet {$0.dateFormat = "MMM dd EEEE"}}()
    
    // For header
    @IBOutlet weak var dateLabel: UILabel!
    @IBAction func prevDayAction(_ sender: UIButton) {
        print("Prev")
        moveTo(.Prev)
    }
    @IBAction func nextDayAction(_ sender: UIButton) {
        print("Next")
        moveTo(.Next)
    }
    
    private enum DayTo {
        case Prev
        case Next
    }
    
    private func moveTo(_ dayTo: DayTo) {
        var dateConmonents = DateComponents()
        dateConmonents.year = date.year
        dateConmonents.month = date.month
        dateConmonents.day = dayTo == .Prev ? (date - 1.day).day : (date + 1.day).day

        innerInitialize(date: (DateInRegion(components: dateConmonents)?.absoluteDate)!)
        initializeView()
    }

    // For summary
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var totalExpenditureLabel: UILabel!
    @IBOutlet weak var totalRevenueLabel: UILabel!

    // For table
    @IBOutlet weak var tableView: UITableView!
}

/**---------------------------------------------------------------
 * Override methods
 * --------------------------------------------------------------- */
extension ListUpDailyReportsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }
}

/**---------------------------------------------------------------
 * Initializer
 * --------------------------------------------------------------- */
extension ListUpDailyReportsViewController {
    func initialize(date: Date) {
        self.date = date
        expenses = Array(ExpenseDao().findForDay(date: date))
    }
    
    fileprivate func innerInitialize(date: Date) {
        initialize(date: date)
        tableView.reloadData()
    }
    
    fileprivate func initializeView() {
        // set header date text
        dateLabel.text = dateFormatter.string(from: date).capitalized
        
        // set total amount
        let expenseDao = ExpenseDao()
        totalAmountLabel.text = expenseDao.getTotalAmountForDay(date: date).formatCurrency()
        totalExpenditureLabel.text = expenseDao.getTotalExpenditureLabelForDay(date: date).formatCurrency()
        totalRevenueLabel.text = expenseDao.getTotalRevenueForDay(date: date).formatCurrency()
    }
}

/**---------------------------------------------------------------
 * Implementation methods for table view
 * --------------------------------------------------------------- */
extension ListUpDailyReportsViewController {
    // getView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return (tableView.dequeueReusableCell(
            withIdentifier: cellIdentifer,
            for: indexPath) as! ListUpDailyReportsCell).applyRet { $0.setExpense(expenses[indexPath.row]) }
    }

    // getCount
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
}
