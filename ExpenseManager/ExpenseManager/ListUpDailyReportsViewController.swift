import UIKit

class ListUpDailyReportsViewController: UIViewController {

    fileprivate var date: Date = Date()
    internal var expenses: Array<Expense> = []
    
    
    
}

/**---------------------------------------------------------------
 * Override methods
 * --------------------------------------------------------------- */
extension ListUpDailyReportsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

/**---------------------------------------------------------------
 * Initializer
 * --------------------------------------------------------------- */
extension ListUpDailyReportsViewController {
    func initialize(date: Date) {
        expenses = Array(ExpenseDao().findForDay(date: date))
    }
}

