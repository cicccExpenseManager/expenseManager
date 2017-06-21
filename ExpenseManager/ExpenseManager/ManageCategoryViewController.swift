import UIKit

class ManageCategoryViewController: UIViewController {
    
    // For data table
    fileprivate var categories: Array<Category> = []
    fileprivate let cellIdentifer = "ManageCategoryCell"

    // Definitions of views
    @IBOutlet weak var addCategoryColor: UIView!
    @IBOutlet weak var addCategoryName: UITextField!
    @IBAction func addCategoryAction(_ sender: Any) { showDialog() }
    @IBOutlet weak var tableView: UITableView!
}

/**---------------------------------------------------------------
 * Override methods
 * --------------------------------------------------------------- */
extension ManageCategoryViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeData()
        self.navigationController?.title = "Edit Category"
    }
    
    fileprivate func showDialog() {
        
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
            for: indexPath) as! ManageCategoryCell).applyRet {
                $0.setCategory(categories[indexPath.row])
        }
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
            UIAlertController(title: "CONFIRM", message: "Are you sure?", preferredStyle: .alert).apply {
                let otherAction = UIAlertAction(title: "DELETE", style: .default) {
                    action in self.deleteRecord(forRowAt: indexPath)
                }
                $0.addAction(otherAction)
                $0.addAction(UIAlertAction(title: "CANCEL", style: .default) {
                    action in self.tableView.isEditing = false
                })
                present($0, animated: true, completion: nil)
            }
        }
    }
    
    func deleteRecord(forRowAt indexPath: IndexPath) {
        // delete record
        let category = categories[indexPath.row]
        CategoryDao().delete(category: category)
        
        // remove row item
        categories.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        print(indexPath.row)
    }
}
