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

    fileprivate func initializeView() {
        // Note : All delegates are set in view controller
//        self.navigationController!.navigationBar.apply {
//            // Status bar white font
//            $0.barStyle = UIBarStyle.black
//            $0.tintColor = UIColor.white
//
//            // Navigation bar to alpha zero
//            $0.setBackgroundImage(UIImage(), for: .default)
//            $0.shadowImage = UIImage()
//        }

//        // set calendar height if the device is iPad
//        if UIDevice.current.model.hasPrefix("iPad") {
//            self.calendarHeightConstraint.constant = 400
//        }
//
//        // set up calendar
//        self.calendar.apply {
//            // set gesture recognizer to table view
//            $0.addGestureRecognizer(self.scopeGesture)
//            
//            // select today to calendar
//            $0.select(Date())
//            
//            // set calendar mode for default
//            $0.scope = .month
//            
//            // disable border of top and bottom
//            $0.clipsToBounds = true
//        }
    }
}
