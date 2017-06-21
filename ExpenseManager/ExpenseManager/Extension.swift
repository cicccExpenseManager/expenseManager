import UIKit

extension UIColor {
    var redValue: CGFloat{ return CIColor(color: self).red }
    var greenValue: CGFloat{ return CIColor(color: self).green }
    var blueValue: CGFloat{ return CIColor(color: self).blue }
    var alphaValue: CGFloat{ return CIColor(color: self).alpha }
}

extension Double {
    func formatCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: Locale.current.identifier)
        let result = formatter.string(from: self as NSNumber)
        return result!
    }
}

protocol ApplyProtocol {}

extension ApplyProtocol {
    func applyRet(_ closure: (_ this: Self) -> Void) -> Self {
        closure(self)
        return self
    }
    
    func apply(_ closure: (_ this: Self) -> Void) {
        closure(self)
    }
}

extension NSObject: ApplyProtocol {}
