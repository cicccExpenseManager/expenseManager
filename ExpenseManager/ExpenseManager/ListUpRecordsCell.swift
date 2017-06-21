import UIKit

class ListUpRecordsCell: UITableViewCell {
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var categoryColor: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        if (categoryColor != nil) {
            let color = categoryColor.backgroundColor
            super.setSelected(selected, animated: animated)
            
            if (categoryColor != nil && selected) {
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

    func setExpense(_ expense: Expense) {
        expense.apply {
            self.categoryColor.backgroundColor = $0.type?.getColor() ?? UIColor.black
            self.detailLabel.text = "\($0.formatDate()), \($0.name)"
            self.amountLabel.text = $0.amount.formatCurrency()
        }
    }
}
