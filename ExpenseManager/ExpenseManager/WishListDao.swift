//
//  WishListDao.swift
//  ExpenseManager
//
//  Created by KimSoo Ha on 2017-06-20.
//  Copyright © 2017 Hiroki Honda. All rights reserved.
//

import Foundation
import RealmSwift

class WishListDao {
        private let realm = try! Realm()
    
//    init() {
//        if Option.DEBUG {
//            if findAllWishListAcounts().isEmpty {
//                for i in 0...4 {
//                    WishList().apply {
//                        $0.amount = 100.00
//                        $0.name = "test \(i)"
//                        insert(wishList: $0)
//                    }
//                }
//            }
//        }
//    }

    
    func findAllWishListAcounts() -> Results<WishList> {
        return realm.objects(WishList.self).sorted(byKeyPath: "id")
    }
    
    func insert(wishList: WishList) {
        try! realm.write {
            wishList.id = generateId()
            realm.add(wishList)
        }
    }
    
    func getTotalAmount() -> Double {
        return findAllWishListAcounts().sum(ofProperty: "amount")
    }
    
    func generateId() -> Int {
        return (findAllWishListAcounts().sorted(byKeyPath: "id").last?.id).map{ $0 + 1 } ?? 1
    }
    
    func delete(wishListAmount: WishList) {
        try! realm.write {
            realm.delete(wishListAmount)
        }
    }

}
