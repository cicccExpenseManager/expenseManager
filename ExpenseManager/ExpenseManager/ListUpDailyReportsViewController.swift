import UIKit
import SwiftDate


class ListUpDailyReportsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // For data table
    fileprivate var date: Date = Date()
    internal var expenses: Array<Expense> = []
    fileprivate let cellIdentifer = "ListUpDailyRecordsCell"
    fileprivate let dateFormatter: DateFormatter = {
        return DateFormatter().applyRet {$0.dateFormat = "MMMM dd EEE"}}()
    
    // For header
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func addExpenseAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "InputPage", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "inputPage") as! InputPage
        vc.selectedDate = date
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func prevDayAction(_ sender: UIButton) {
        moveTo(.Prev)
    }
    @IBAction func nextDayAction(_ sender: UIButton) {
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
    }

    // For summary
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var totalExpenditureLabel: UILabel!
    @IBOutlet weak var totalRevenueLabel: UILabel!

    // For table
    @IBOutlet weak var tableView: UITableView!
    
    // For other
    var selectUpdateDelegate: SelectedUpdateDelegate?
}

/**---------------------------------------------------------------
 * Override methods
 * --------------------------------------------------------------- */
extension ListUpDailyReportsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let recordCount = ExpenseDao().findForDay(date: date).count
        if (expenses.count != recordCount) {
            innerInitialize(date: date)
        }
    }
}

/**---------------------------------------------------------------
 * Initializer
 * --------------------------------------------------------------- */
extension ListUpDailyReportsViewController {
    func initializeData(date: Date) {
        self.date = date
        expenses = Array(ExpenseDao().findForDay(date: date))
    }
    
    fileprivate func innerInitialize(date: Date) {
        selectUpdateDelegate?.requestChanged(date)
        initializeData(date: date)
        initializeView()
        tableView.reloadData()
    }
    
    fileprivate func initializeView() {
        // set header date text
        dateLabel.text = dateFormatter.string(from: date).uppercased()
        
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            // delete record
            let expense = expenses[indexPath.row]
            ExpenseDao().delete(expense: expense)
            
            // remove row item
            expenses.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            print(indexPath.row)
            
            // initialize view
            initializeView()
        }
    }
}
