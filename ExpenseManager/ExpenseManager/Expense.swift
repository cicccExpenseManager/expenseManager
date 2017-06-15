import Foundation
import RealmSwift

class Expense: Object {
    dynamic var id = 1
    dynamic var amount: Double = 0.0
    dynamic var type: Category?
    dynamic var typeId = 1
    dynamic var date = NSDate()
    dynamic var name: String = ""

    override static func primaryKey() -> String? {
        return "id"
    }
    
    func setType(category: Category) {
        type = category
        typeId = category.id
    }
    
    func formatDate() -> String {
        return dateFormatter.string(from: date as Date)
    }
    
    fileprivate let dateFormatter: DateFormatter = {
        return DateFormatter().applyRet {$0.dateFormat = "yyyy/MM/dd"}}()
}
