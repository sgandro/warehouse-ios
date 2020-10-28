//
//  Phone.swift
//  warehouse
//
//  Created by Alessandro Perna on 28/10/2020.
//

import Foundation
import RealmSwift

class Phone: Object{
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var type: String = ""
    @objc dynamic var number: String = ""
    let suppliers = LinkingObjects(fromType: Supplier.self, property: "phones")

    override static func primaryKey() -> String? {
        return "id"
    }
}
