import UIKit

class ManageCategoryCell: UITableViewCell {

    @IBOutlet weak var categoryColor: UIView!
    @IBOutlet weak var categoryName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCategory(_ category: Category) {
        categoryColor.backgroundColor = category.getColor()
        categoryName.text = category.name
    }

}
