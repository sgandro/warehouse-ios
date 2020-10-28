//
//  Email.swift
//  warehouse
//
//  Created by Alessandro Perna on 28/10/2020.
//

import Foundation
import RealmSwift

class Email: Object{
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var type: String = ""
    @objc dynamic var address: String = ""
    let suppliers = LinkingObjects(fromType: Supplier.self, property: "emails")

    override static func primaryKey() -> String? {
        return "id"
    }


}
