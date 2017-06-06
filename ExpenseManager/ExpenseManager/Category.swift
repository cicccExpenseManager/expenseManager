import Foundation
import RealmSwift

class Category: Object {
    dynamic var name = ""

    override static func primaryKey() -> String? {
        return "name"
    }
}
