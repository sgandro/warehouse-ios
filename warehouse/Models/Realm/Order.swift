//
//  Order.swift
//  warehouse
//
//  Created by Alessandro Perna on 06/11/2020.
//

import Foundation
import RealmSwift

class Order: Object{
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var date: Date = Date()

    let items = List<Item>()

    override static func primaryKey() -> String? {
        return "id"
    }

}
