//
//  TableConfigurator.swift
//  warehouse
//
//  Created by Alessandro Perna on 31/10/2020.
//

import Foundation


class TableConfigurator{

    public static func getPlistFile(root:String, resourceName:String)->[[String:Any]]?{
        guard
            let path = Bundle.main.path(forResource: resourceName, ofType: "plist", inDirectory: nil)
        else { return nil }

        let url = URL(fileURLWithPath: path)
        do{

            let data = try Data(contentsOf: url)
            guard
                let plist = try! PropertyListSerialization.propertyList(from: data,
                                                                          options: .mutableContainers,
                                                                          format: nil) as? [String:Any]
            else { return nil }

            return plist[root] as? [[String:Any]]
        }catch{
            return nil
        }

    }
}



