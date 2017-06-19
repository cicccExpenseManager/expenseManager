//
//  ExpectedAcountDao.swift
//  ExpenseManager
//
//  Created by KimSoo Ha on 2017-06-19.
//  Copyright © 2017 Hiroki Honda. All rights reserved.
//

import Foundation
import RealmSwift

class ExpectedAmountDao {
    private let realm = try! Realm()
    
    func findAllExpectedAcounts() -> Results<ExpectedAmount> {
        return realm.objects(ExpectedAmount.self)
    }
}
