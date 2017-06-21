import UIKit

class ManageCategoryCell: UITableViewCell {

    @IBOutlet weak var categoryColor: UIView!
    @IBOutlet weak var categoryName: UILabel!

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
    
    func setCategory(_ category: Category) {
        categoryColor.backgroundColor = category.getColor()
        categoryName.text = category.name
    }

}
