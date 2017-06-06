import Foundation
import RealmSwift

class ExpenseDao {

    var realm: Realm!

    init() {
        realm = try! Realm()
        print(realm)
        
        
        if (Option.DEBUG) {
            if (findAllExpenses().isEmpty) {
                let categoryDao = CategoryDao()
                categoryDao.initializeIfNeeded();
                let categoryCounts = categoryDao.findAllCategories().count
                let categoryArray = Array(categoryDao.findAllCategories())

                // Put some expenses for debug
                try! realm?.write {
                    for _ in 0...20 {
                        let expense = Expense()
                        expense.id = generateId()
                        expense.amount = 50.00
                        let randomCategoryIndex =
                            Int(arc4random_uniform(UInt32(categoryCounts)))
                        expense.type = categoryArray[randomCategoryIndex]
                        expense.date = NSDate()
                        print(expense)
                        realm.add(expense)
                    }
                }
            }
        }
    }

    func generateId() -> Int {
        return (findAllExpenses().last?.id).map{ $0 + 1 } ?? 1
    }

    func findAllExpenses() -> Results<Expense> {
        let realm = try! Realm()
        return realm.objects(Expense.self)
    }
}
