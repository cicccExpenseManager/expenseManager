import UIKit

class ListUpDailyReportsCell: UITableViewCell {
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var categoryColor: UIView!
    @IBOutlet weak var amountLabel: UILabel!

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

    func setExpense(_ expense: Expense) {
        expense.apply {
            detailLabel.text = $0.name
            categoryColor.backgroundColor = $0.type?.getColor() ?? UIColor.black
            self.amountLabel.text = $0.amount.formatCurrency()
        }
    }
}
