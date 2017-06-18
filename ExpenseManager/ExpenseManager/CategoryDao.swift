import Foundation
import RealmSwift
import UIKit

class CategoryDao {
    
    private let realm = try! Realm()

    func findAllCategories() -> Results<Category> {
        return realm.objects(Category.self)
    }
    
    func findByName(name: String) -> Results<Category> {
        return findAllCategories().filter("name = %@", [name])
    }

    /**
     * Put default categories if the Category Table does not have any record.
     */
    func initializeIfNeeded() {
        if (realm.objects(Category.self).isEmpty) {
            try! realm.write {
                // Put some categories for debug
                for i in 1..<10 {
                    Category().apply {
                        $0.id = generateId()
                        let colorName: String
                        switch i {
                        case 1:
                            colorName = "DarkGray"
                            $0.setColor(color: UIColor.darkGray)
                        case 2:
                            colorName = "Blue"
                            $0.setColor(color: UIColor.blue)
                        case 3:
                            colorName = "Brown"
                            $0.setColor(color: UIColor.brown)
                        case 4:
                            colorName = "Cyan"
                            $0.setColor(color: UIColor.cyan)
                        case 5:
                            colorName = "Gray"
                            $0.setColor(color: UIColor.gray)
                        case 6:
                            colorName = "Green"
                            $0.setColor(color: UIColor.green)
                        case 7:
                            colorName = "Red"
                            $0.setColor(color: UIColor.red)
                        case 8:
                            colorName = "Purple"
                            $0.setColor(color: UIColor.purple)
                        case 9:
                            colorName = "Orange"
                            $0.setColor(color: UIColor.orange)
                        case 10:
                            colorName = "Magenta"
                            $0.setColor(color: UIColor.magenta)
                        default:
                            colorName = "Black"
                            $0.setColor(color: UIColor.black)
                        }
                        $0.name = "Category \(colorName)"
                        realm.add($0)
                    }
                }
            }
        }
    }
    
    func generateId() -> Int {
        return (findAllCategories().sorted(byKeyPath: "id").last?.id).map{ $0 + 1 } ?? 1
    }
}
