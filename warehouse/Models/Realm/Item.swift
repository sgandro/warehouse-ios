//
//  Item.swift
//  warehouse
//
//  Created by Alessandro Perna on 18/10/2020.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    let categories = LinkingObjects(fromType: Category.self, property: "items")

    override static func primaryKey() -> String? {
        return "id"
    }
}
