
import Foundation
import RealmSwift

class ExpectedAmount: Object {

    dynamic var id = 1
    dynamic var name:String = ""
    dynamic var amount: Double = 0.0
    dynamic var finished = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func setAmount(newAmount: Double, newName: String) {
        amount = newAmount
        name = newName
    }

}
