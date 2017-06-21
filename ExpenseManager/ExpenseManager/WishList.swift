//
//  WishList.swift
//  ExpenseManager
//
//  Created by KimSoo Ha on 2017-06-20.
//  Copyright © 2017 Hiroki Honda. All rights reserved.
//

import Foundation
import RealmSwift

class WishList: Object {
    
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
