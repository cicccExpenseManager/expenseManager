import Foundation
import RealmSwift
import SwiftDate

class ExpenseDao {

    private let realm = try! Realm()
    
    private static let sortProperties = [
        SortDescriptor(keyPath: "date"),
        SortDescriptor(keyPath: "typeId")]

    init() {
        if (findAllExpenses().isEmpty) {
            let categoryDao = CategoryDao()
            categoryDao.initializeIfNeeded();
            let categoryCounts = categoryDao.findAllCategories().count
            let categoryArray = Array(categoryDao.findAllCategories())

            if (Option.DEBUG) {
                // Put some expenses for debug
                try! realm.write {
                    for i in 0...200 {
                        Expense().apply {
                            $0.id = generateId()
                            $0.amount = -100.00 + Double(arc4random_uniform(500))
                            let randomCategoryIndex =
                                Int(arc4random_uniform(UInt32(categoryCounts)))
                            $0.setType(category: categoryArray[randomCategoryIndex])
                            let dayDifference = Int(arc4random_uniform(UInt32(100))).day
                            if (arc4random_uniform(2) == 0) {
                                $0.date = (Date() + dayDifference) as NSDate
                            } else {
                                $0.date = (Date() - dayDifference) as NSDate
                            }
                            $0.name = "Detail \(i + 1)"
                            
                            realm.add($0)
                        }
                    }
                }
            }
        }
    }

    func generateId() -> Int {
        return (findAllExpenses().sorted(byKeyPath: "id").last?.id).map{ $0 + 1 } ?? 1
    }

    func findAllExpenses() -> Results<Expense> {
        return realm.objects(Expense.self)
    }
    
    private func findSortedAllExpenses() -> Results<Expense> {
        return findAllExpenses().sorted(by: ExpenseDao.sortProperties)
    }
    
    private func generateDataComponents(year: Int, month: Int) -> DateComponents {
        var dataComponents = DateComponents()
        dataComponents.year = year
        dataComponents.month = month
        return dataComponents
    }
    
    private func generateDataComponents(year: Int, month: Int, day: Int) -> DateComponents {
        var dataComponents = generateDataComponents(year: year, month: month)
        dataComponents.day = day
        return dataComponents
    }
    
    func findForMonth(date: Date) -> Results<Expense> {
        let dataComponents = generateDataComponents(year: date.year, month: date.month)
        return findSortedAllExpenses().filter("date BETWEEN %@", [
            DateInRegion(components: dataComponents)?.startOf(component: .month).absoluteDate,
            DateInRegion(components: dataComponents)?.endOf(component: .month).absoluteDate])
    }
    
    func findForWeek(date: Date) -> Results<Expense> {
        let dataComponents = generateDataComponents(year: date.year, month: date.month, day: date.day)
        return findSortedAllExpenses().filter("date BETWEEN %@", [
            DateInRegion(components: dataComponents)?.startWeek.absoluteDate,
            DateInRegion(components: dataComponents)?.endWeek.absoluteDate])
    }

    func findForDay(date: Date) -> Results<Expense> {
        let dataComponents = generateDataComponents(year: date.year, month: date.month, day: date.day)
        return findSortedAllExpenses().filter("date BETWEEN %@", [
            DateInRegion(components: dataComponents)?.startOfDay.absoluteDate,
            DateInRegion(components: dataComponents)?.endOfDay.absoluteDate])
    }

    func getTotalAmount() -> Double {
        return realm.objects(Expense.self).sum(ofProperty: "amount")
    }
    
    func getTotalAmountForDay(date: Date) -> Double {
        return findForDay(date: date).sum(ofProperty: "amount")
    }

    func getTotalExpenditureLabelForDay(date: Date) -> Double {
        return findForDay(date: date).filter("amount < %@", 0).sum(ofProperty: "amount")
    }

    func getTotalRevenueForDay(date: Date) -> Double {
        return findForDay(date: date).filter("amount > %@", 0).sum(ofProperty: "amount")
    }
}
