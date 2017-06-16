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
        let color = categoryColor.backgroundColor
        super.setSelected(selected, animated: animated)
        
        if (selected) {
            categoryColor.backgroundColor = color
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
        self.categoryColor.backgroundColor = expense.type?.getColor() ?? UIColor.black
        self.detailLabel.text = "\(expense.formatDate()), \(expense.name)"
        self.amountLabel.text = formatCurrency(expense.amount)
    }

    func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: Locale.current.identifier)
        let result = formatter.string(from: value as NSNumber)
        return result!
    }
}
