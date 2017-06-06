import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    var expenses: Array<Expense> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeData()
        initializeView()
    }
}

/**
 * Initializer
 */
extension ViewController {
    func initializeData() {
        let expenseDao = ExpenseDao()
        expenses = Array(expenseDao.findAllExpenses())
    }
    
    func initializeView() {
        // create views
        let windowRect = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        tableView = UITableView(frame: windowRect)
        
        // add table to view
        view.addSubview(tableView)
        
        // set interfaces
        tableView.delegate = self
        tableView.dataSource = self
    }
}

/**
 * Implementation methods for table view
 */
extension ViewController {
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
}

