//
//  Suppliers.swift
//  warehouse
//
//  Created by Alessandro Perna on 28/10/2020.
//

import Foundation
import RealmSwift

class Supplier: Object{
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var businessName: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var surname: String = ""
    @objc dynamic var vatNumber: String = ""
    @objc dynamic var fiscalCode: String = ""

    let emails = List<Email>()
    let addresses = List<Address>()
    let phones = List<Phone>()
    let banks = List<Bank>()
    let categories = LinkingObjects(fromType: Category.self, property: "suppliers")

    override static func primaryKey() -> String? {
        return "id"
    }


}
