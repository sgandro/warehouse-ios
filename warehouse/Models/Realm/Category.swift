//
//  Category.swift
//  warehouse
//
//  Created by Alessandro Perna on 18/10/2020.
//

import Foundation
import RealmSwift

class Category: Object{
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    let items = List<Item>()
    let department = LinkingObjects(fromType: Department.self, property: "categories")

    override static func primaryKey() -> String? {
        return "id"
    }
}
