//
//  UITableView+Extension.swift
//  ER-Salute
//
//  Created by Laura Pugliese on 02/12/2019.
//  Copyright © 2019 Almaviva Spa. All rights reserved.
//

import UIKit
import RealmSwift


extension UITableView {

    func applayChanges<T>(changes: RealmCollectionChange<T>){
        switch changes {
        case .initial:
            reloadData()
        case .update( _, deletions: let deletions, insertions: let insertions, modifications: let updates):

            beginUpdates()
            insertRows(at: insertions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
            reloadRows(at: updates.map({IndexPath(row: $0, section: 0)}), with: .automatic)
            deleteRows(at: deletions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
            endUpdates()

        case .error(let error): fatalError("\(error)")
        }
    }

    
}
