import UIKit

class ManageCategoryCell: UITableViewCell {

    @IBOutlet weak var categoryColor: UIView!
    @IBOutlet weak var categoryName: UILabel!
    @IBAction func colorAction(_ sender: UIButton) {
        showColorPicker()
    }
    
    var category: Category?
    var vc: UIViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if (categoryColor != nil) {
            let color = categoryColor.backgroundColor
            super.setSelected(selected, animated: animated)
            
            if (selected) {
                categoryColor.backgroundColor = color
            }
            
        } else {
            super.setSelected(selected, animated: animated)
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let color = categoryColor.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        
        if (highlighted) {
            categoryColor.backgroundColor = color
        }
    }
    
    func setInstances(_ category: Category, viewController vc: UIViewController) {
        self.vc = vc
        self.category = category
        categoryColor.backgroundColor = category.getColor()
        categoryName.text = category.name
    }
    
    fileprivate func showColorPicker() {
        // TODO grade up using color pick library
        if (category == nil) {
            return
        }
        UIAlertController(title: "SELECT COLOR", message: nil, preferredStyle: .alert).apply {
            $0.addAction(UIAlertAction(title: "Yellow", style: .default) {
                action in self.setColor(UIColor.yellow)
            })
            $0.addAction(UIAlertAction(title: "Orange", style: .default) {
                action in self.setColor(UIColor.orange)
            })
            $0.addAction(UIAlertAction(title: "Red", style: .default) {
                action in self.setColor(UIColor.red)
            })
            $0.addAction(UIAlertAction(title: "Magenta", style: .default) {
                action in self.setColor(UIColor.magenta)
            })
            $0.addAction(UIAlertAction(title: "Purple", style: .default) {
                action in self.setColor(UIColor.purple)
            })
            $0.addAction(UIAlertAction(title: "Blue", style: .default) {
                action in self.setColor(UIColor.blue)
            })
            $0.addAction(UIAlertAction(title: "Cyan", style: .default) {
                action in self.setColor(UIColor.cyan)
            })
            $0.addAction(UIAlertAction(title: "Brown", style: .default) {
                action in self.setColor(UIColor.brown)
            })
            $0.addAction(UIAlertAction(title: "DarkGray", style: .default) {
                action in self.setColor(UIColor.darkGray)
            })
            $0.addAction(UIAlertAction(title: "Gray", style: .default) {
                action in self.setColor(UIColor.gray)
            })
            $0.addAction(UIAlertAction(title: "LightGray", style: .default) {
                action in self.setColor(UIColor.lightGray)
            })
            $0.addAction(UIAlertAction(title: "CANCEL", style: .cancel))
            vc?.present($0, animated: true, completion: nil)
        }
    }
    
    private func setColor(_ color: UIColor) {
        CategoryDao().updateColor(category!, color)
        categoryColor.backgroundColor = category?.getColor()
    }

}
