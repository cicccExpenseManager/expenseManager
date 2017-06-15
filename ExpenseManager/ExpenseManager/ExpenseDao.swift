import Foundation
import RealmSwift
import SwiftDate

class ExpenseDao {

    var realm: Realm!

    init() {
        realm = try! Realm()
        
        if (Option.DEBUG) {
            if (findAllExpenses().isEmpty) {
                let categoryDao = CategoryDao()
                categoryDao.initializeIfNeeded();
                let categoryCounts = categoryDao.findAllCategories().count
                let categoryArray = Array(categoryDao.findAllCategories())

                // Put some expenses for debug
                try! realm?.write {
                    for _ in 0...60 {
                        Expense().apply {
                            $0.id = generateId()
                            $0.amount = 50.00 + Double(arc4random_uniform(500))
                            let randomCategoryIndex =
                                Int(arc4random_uniform(UInt32(categoryCounts)))
                            $0.setType(category: categoryArray[randomCategoryIndex])
                            let dayDifference = Int(arc4random_uniform(UInt32(15))).day
                            if (arc4random_uniform(2) == 0) {
                                $0.date = (Date() + dayDifference) as NSDate
                            } else {
                                $0.date = (Date() - dayDifference) as NSDate
                            }
                            
                            realm.add($0)
                        }
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
    
    func findForMonth(date: Date) -> Results<Expense> {
        var dataComponents = DateComponents()
        dataComponents.year = date.year
        dataComponents.month = date.month
        return realm.objects(Expense.self).sorted(byKeyPath: "date").filter("date BETWEEN %@", [
            DateInRegion(components: dataComponents)?.startOf(component: .month).absoluteDate,
            DateInRegion(components: dataComponents)?.endOf(component: .month).absoluteDate])
    }
    
    func findForWeek(date: Date) -> Results<Expense> {
        var dataComponents = DateComponents()
        dataComponents.year = date.year
        dataComponents.month = date.month
        dataComponents.day = date.day
        return realm.objects(Expense.self).sorted(byKeyPath: "date").filter("date BETWEEN %@", [
            DateInRegion(components: dataComponents)?.startWeek.absoluteDate,
            DateInRegion(components: dataComponents)?.endWeek.absoluteDate])
    }

    func findForDay(date: Date) -> Results<Expense> {
        var dataComponents = DateComponents()
        dataComponents.year = date.year
        dataComponents.month = date.month
        dataComponents.day = date.day
        return realm.objects(Expense.self).filter("date BETWEEN %@", [
            DateInRegion(components: dataComponents)?.startOfDay.absoluteDate,
            DateInRegion(components: dataComponents)?.endOfDay.absoluteDate])
    }
    
    func findForDayOrderByType(date: Date) -> Results<Expense> {
        return findForDay(date: date).sorted(byKeyPath: "typeId")
    }
}
