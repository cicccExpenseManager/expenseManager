import Foundation
import RealmSwift

class CategoryDao {
    
    private let realm = try! Realm()

    func findAllCategories() -> Results<Category> {
        return realm.objects(Category.self)
    }

    /**
     * Put default categories if the Category Table does not have any record.
     */
    func initializeIfNeeded() {
        if (realm.objects(Category.self).isEmpty) {
            try! realm.write {
                // Put some categories for debug
                for i in 1..<10 {
                    let category = Category()
                    category.name = "Category \(i)"
                    realm.add(category)
                }
            }
        }
    }
}
