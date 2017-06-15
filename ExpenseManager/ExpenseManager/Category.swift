import Foundation
import RealmSwift
import UIKit

class Category: Object {
    dynamic var id = 1
    dynamic var name = ""
    dynamic var colorRed: Float = 0
    dynamic var colorBlue: Float = 0
    dynamic var colorGreen: Float = 0

    override static func primaryKey() -> String? {
        return "name"
    }

    func getColor() -> UIColor {
        return UIColor(colorLiteralRed: colorRed, green: colorGreen, blue: colorBlue, alpha: 1.0)
    }

    func setColor(color: UIColor) {
        self.colorRed = Float(color.redValue)
        self.colorBlue = Float(color.blueValue)
        self.colorGreen = Float(color.greenValue)
    }
}
