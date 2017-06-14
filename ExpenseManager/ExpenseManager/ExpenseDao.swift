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
                    for _ in 0...30 {
                        Expense().apply {
                            $0.id = generateId()
                            $0.amount = 50.00
                            let randomCategoryIndex =
                                Int(arc4random_uniform(UInt32(categoryCounts)))
                            $0.type = categoryArray[randomCategoryIndex]
                            let newdate = Date(timeIntervalSinceNow: 100)
                            $0.date = newdate as NSDate
                            
                            realm.add($0)
                        }
                        
//                        let randomCategoryIndex =
//                            Int(arc4random_uniform(UInt32(30)))
//                        expense.date = NSDate()
//                        NSCalendar.
                    }
                }
            }
        }
    }

    func generateId() -> Int {
        return (findAllExpenses().last?.id).map{ $0 + 1 } ?? 1
//        return (findAllExpenses().sorted(byKeyPath: "expense.id").last?.id).map{ $0 + 1 } ?? 1
    }

    func findAllExpenses() -> Results<Expense> {
      
        return realm.objects(Expense.self)
    }
}
