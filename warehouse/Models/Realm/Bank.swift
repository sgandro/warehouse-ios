//
//  Bank.swift
//  warehouse
//
//  Created by Alessandro Perna on 29/10/2020.
//

import Foundation
import RealmSwift

class Bank: Object{
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var iban: String = ""
    @objc dynamic var swift: String = ""

    let emails = List<Email>()
    let addresses = List<Address>()
    let phones = List<Phone>()

    override static func primaryKey() -> String? {
        return "id"
    }

}
