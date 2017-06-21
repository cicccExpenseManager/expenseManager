import UIKit

class ManageCategoryViewController: UIViewController {
    
    // For data table
    fileprivate var categories: Array<Category> = []
    fileprivate let cellIdentifer = "ManageCategoryCell"

    // Definitions of views
    @IBOutlet weak var addCategoryColor: UIView!
    @IBAction func addCategoryColorAction(_ sender: Any) {
        showColorPicker()
    }

    @IBOutlet weak var addCategoryName: UITextField!
    @IBAction func addCategoryAction(_ sender: Any) { showColorPicker() }
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate func showColorPicker() {
        // TODO grade up using color pick library
        UIAlertController(title: "SELECT COLOR", message: nil, preferredStyle: .alert).apply {
            $0.addAction(UIAlertAction(title: "Yellow", style: .default) {
                action in self.addCategoryColor.backgroundColor = UIColor.yellow
            })
            $0.addAction(UIAlertAction(title: "Orange", style: .default) {
                action in self.addCategoryColor.backgroundColor = (UIColor.orange)
            })
            $0.addAction(UIAlertAction(title: "Red", style: .default) {
                action in self.addCategoryColor.backgroundColor = (UIColor.red)
            })
            $0.addAction(UIAlertAction(title: "Magenta", style: .default) {
                action in self.addCategoryColor.backgroundColor = (UIColor.magenta)
            })
            $0.addAction(UIAlertAction(title: "Purple", style: .default) {
                action in self.addCategoryColor.backgroundColor = (UIColor.purple)
            })
            $0.addAction(UIAlertAction(title: "Blue", style: .default) {
                action in self.addCategoryColor.backgroundColor = (UIColor.blue)
            })
            $0.addAction(UIAlertAction(title: "Cyan", style: .default) {
                action in self.addCategoryColor.backgroundColor = (UIColor.cyan)
            })
            $0.addAction(UIAlertAction(title: "Brown", style: .default) {
                action in self.addCategoryColor.backgroundColor = (UIColor.brown)
            })
            $0.addAction(UIAlertAction(title: "DarkGray", style: .default) {
                action in self.addCategoryColor.backgroundColor = (UIColor.darkGray)
            })
            $0.addAction(UIAlertAction(title: "Gray", style: .default) {
                action in self.addCategoryColor.backgroundColor = (UIColor.gray)
            })
            $0.addAction(UIAlertAction(title: "LightGray", style: .default) {
                action in self.addCategoryColor.backgroundColor = (UIColor.lightGray)
            })
            $0.addAction(UIAlertAction(title: "CANCEL", style: .cancel))
            present($0, animated: true, completion: nil)
        }
    }
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
                $0.setInstances(categories[indexPath.row], viewController: self)
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
                $0.addAction(UIAlertAction(title: "CANCEL", style: .cancel) {
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
