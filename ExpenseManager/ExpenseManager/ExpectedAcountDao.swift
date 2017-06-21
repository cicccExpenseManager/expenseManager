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
    
    
    init() {
        if Option.DEBUG {
            if findAllExpectedAcounts().isEmpty {
                for i in 0...4 {
                    ExpectedAmount().apply {
                        $0.amount = 100.00
                        $0.name = "test \(i)"
                        insert(expectedAmount: $0)
                    }
                }
            }
        }
    }
    

    
    func findAllExpectedAcounts() -> Results<ExpectedAmount> {
        return realm.objects(ExpectedAmount.self).sorted(byKeyPath: "id")
    }
    
    func insert(expectedAmount: ExpectedAmount) {
        try! realm.write {
            expectedAmount.id = generateId()
            realm.add(expectedAmount)
        }
    }
    
    func delete(expectedAmount: ExpectedAmount) {
        try! realm.write {
            realm.delete(expectedAmount)
        }
    }
    
    func getTotalAmount() -> Double {
        return findAllExpectedAcounts().sum(ofProperty: "amount")
    }
    
    func generateId() -> Int {
        return (findAllExpectedAcounts().sorted(byKeyPath: "id").last?.id).map{ $0 + 1 } ?? 1
    }
}
