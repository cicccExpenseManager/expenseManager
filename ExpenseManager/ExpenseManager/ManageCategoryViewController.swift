import UIKit

class ManageCategoryViewController: UIViewController {
    
    // For data table
    fileprivate var categories: Array<Category> = []
    fileprivate let cellIdentifer = "ManageCategoryCell"

    // Definitions of views
    @IBOutlet weak var addCategoryColor: UIView!
    @IBOutlet weak var addCategoryName: UITextField!
    @IBAction func addCategoryAction(_ sender: Any) {
        
    }
    @IBOutlet weak var tableView: UITableView!
}

/**---------------------------------------------------------------
 * Override methods
 * --------------------------------------------------------------- */
extension ManageCategoryViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeData()
    }
}

/**---------------------------------------------------------------
 * Initializer
 * --------------------------------------------------------------- */
extension ManageCategoryViewController {
    fileprivate func initializeData() {
        categories = Array(CategoryDao().findAllCategories())
    }
}

/**---------------------------------------------------------------
 * Implementation methods for table view
 * --------------------------------------------------------------- */
extension ManageCategoryViewController: UITableViewDataSource, UITableViewDelegate {
    // getView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return (tableView.dequeueReusableCell(
            withIdentifier: cellIdentifer,
            for: indexPath) as! ManageCategoryCell).applyRet { $0.setCategory(categories[indexPath.row]) }
    }
    
    // getCount
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            if (CategoryDao().findAllCategories().count > 1) {
                print("b")
//                // delete record
//                let category = categories[indexPath.row]
//                CategoryDao().delete(expense: expense)
//                
//                // remove row item
//                expenses.remove(at: indexPath.row)
//                tableView.deleteRows(at: [indexPath], with: .automatic)
//                print(indexPath.row)
//                
//                // initialize view
//                initializeView()
            } else {
                print("a")
            }
        }
    }
}
