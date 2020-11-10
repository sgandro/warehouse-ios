//
//  UICollectionView+Realm.swift
//  WhereApp
//
//  Created by Alessandro Perna on 13/12/17.
//  Copyright © 2017 VJTlabapple. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

extension UICollectionView{
    func applayChanges<T>(changes: RealmCollectionChange<List<T>>){
        
        switch changes {
        case .initial:
            reloadData()
        case .update( _, deletions: let deletions, insertions: let insertions, modifications: let modifications):
            
            performBatchUpdates({
                insertItems(at: insertions.map { IndexPath(row: $0, section: 0) })
                reloadItems(at: modifications.map { IndexPath(row: $0, section: 0) })
                deleteItems(at: deletions.map { IndexPath(row: $0, section: 0) })
            }, completion: {(done) in
                
                let items: Int = self.numberOfItems(inSection: 0)
                if items > 0 {
                    let indexPath = IndexPath(item: items-1, section: 0)
                    self.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition.top)
                }

            })
            
        case .error(let error): fatalError("\(error)")
        }
    }
    
    func applayChanges<T>(changes: RealmCollectionChange<T>){

        switch changes {
        case .initial:
            reloadData()
        case .update( _, deletions: let deletions, insertions: let insertions, modifications: let modifications):

            performBatchUpdates({
                insertItems(at: insertions.map { IndexPath(row: $0, section: 0) })
                reloadItems(at: modifications.map { IndexPath(row: $0, section: 0) })
                deleteItems(at: deletions.map { IndexPath(row: $0, section: 0) })
            }, completion: {(done) in

                let items: Int = self.numberOfItems(inSection: 0)
                if items > 0 {
                    let indexPath = IndexPath(item: items-1, section: 0)
                    self.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionView.ScrollPosition.top)
                }

            })

        case .error(let error): fatalError("\(error)")
        }
    }

}
