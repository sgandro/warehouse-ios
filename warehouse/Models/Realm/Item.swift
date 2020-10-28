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
    @objc dynamic var serialNumber: String = ""
    @objc dynamic var barcode: String = ""
    @objc dynamic var price: Double = 0.0
    @objc dynamic var unitPrice: Double = 0.0
    @objc dynamic var currency: String = ""
    @objc dynamic var minimumStock: Int = 0
    @objc dynamic var unit: String = ""
    @objc dynamic var quantity: Int = 0
    @objc dynamic var vat: Double = 0.0
    @objc dynamic var note: String = ""

    let categories = LinkingObjects(fromType: Category.self, property: "items")
    let suppliers = LinkingObjects(fromType: Supplier.self, property: "items")

    override static func primaryKey() -> String? {
        return "id"
    }
}
