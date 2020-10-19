//
//  Department.swift
//  warehouse
//
//  Created by Alessandro Perna on 18/10/2020.
//

import Foundation
import RealmSwift

class Department: Object{

    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    let categories = List<Category>()

    override static func primaryKey() -> String? {
        return "id"
    }
}


