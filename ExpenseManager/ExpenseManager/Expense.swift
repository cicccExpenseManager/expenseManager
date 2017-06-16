import Foundation
import RealmSwift

class Expense: Object {
    dynamic var id = 1
    dynamic var amount: Double = 0.0
    dynamic var type: Category?
    dynamic var date = NSDate()
    dynamic var name: String = ""
    
    //TODO
//    var simpleDate: String {
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.locale = NSLocale(localeIdentifier: "en_US")
//        dateFormatter.dateFormat = "dd MMM, yyyy"
//        return dateFormatter.stringFromDate(date)
//    }

    override static func primaryKey() -> String? {
        return "id"
    }
}
