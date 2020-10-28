//
//  Address.swift
//  warehouse
//
//  Created by Alessandro Perna on 28/10/2020.
//

import Foundation
import RealmSwift

class Address: Object{
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var type: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var zipCode: String = ""
    @objc dynamic var city: String = ""
    @objc dynamic var location: String = ""
    let suppliers = LinkingObjects(fromType: Supplier.self, property: "addresses")

    override static func primaryKey() -> String? {
        return "id"
    }


}
