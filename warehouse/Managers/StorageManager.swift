//
//  Storage.swift
//  WhereApp
//
//  Created by Alessandro Perna on 07/03/17.
//  Copyright © 2017 VJTlabapple. All rights reserved.
//

import Foundation
import RealmSwift

class StorageManager {
    
    static let sharedInstance : StorageManager = {
        let instance = StorageManager()
        return instance
    }()

    private var realm:Realm?

    var realmFileSize:Int64 {
        
        let byteFormatter = ByteCountFormatter()
        byteFormatter.allowedUnits = [.useMB]
        byteFormatter.countStyle = .binary
        
        if let realmPath = Realm.Configuration.defaultConfiguration.fileURL?.relativePath {
            do {
                let attributes = try FileManager.default.attributesOfItem(atPath:realmPath)
                if let fileSize = attributes[FileAttributeKey.size] as? Int64 {
                    print("File size: \(byteFormatter.string(fromByteCount: fileSize))")
                    return fileSize
                }
            }
            catch (let error) {
                print("FileManager Error: \(error)")
                return -1
            }
        }
        return 0
    }
    
    var checkRealmIsAvailable:Bool {
        
        do{
            let _ = try Realm()
            return true
        }catch{
            print("*** Archivio pieno ***")
            return false
            
        }
        
    }
    
    
    func initializationStorage(){
        
        var config = Realm.Configuration()
        
        config.schemaVersion = 1 // prima versione
        config.schemaVersion = 2 // Fornitori
        config.schemaVersion = 3 // Correlazioni
        config.schemaVersion = 4 // Order
        config.schemaVersion = 5 // inOrder field is added in Item


        print("Realm Database *** file url \(config.fileURL!)")
        print("Realm Database *** schema version \(config.schemaVersion)")

        config.shouldCompactOnLaunch = {(totalBytes, usedBytes) in
            
            let seventyMB = 100 * 1024 * 1024
            let byteFormatter = ByteCountFormatter()
            byteFormatter.allowedUnits = [.useMB]
            byteFormatter.countStyle = .binary

            print("total Bytes In MB \(byteFormatter.string(fromByteCount: Int64(totalBytes)))")
            print("used Bytes In MB \(byteFormatter.string(fromByteCount: Int64(usedBytes)))")
            
            return (totalBytes > seventyMB) && (Double(usedBytes) / Double(totalBytes)) < 0.5
        }
        
        config.migrationBlock = {(migration, oldSchemaVersion) in
            print("Realm Database *** \(#function) migration...")
            if oldSchemaVersion < 2 {

                migration.enumerateObjects(ofType: Item.className()) { (oldObject, newObject) in
                    if oldObject?.objectSchema.properties.contains(where: {$0.name == "currency"}) == true{
                        newObject?.setValue("EUR", forKey: "currency")
                    }
                }
            }
            
        }
        Realm.Configuration.defaultConfiguration = config
        
        do{
            let realm = try Realm(configuration: config)
            realm.refresh()
            print("Realm file :\(config.fileURL!)")
        }catch{
            print("Error to open realm -> \(error.localizedDescription)")
        }

    }

    func beginRealmSession(){

        if self.realm != nil{
            if self.realm!.isInWriteTransaction == false{
                self.realm!.beginWrite()
                print("begin Realm Session")
            }
        }else{
            self.realm = try! Realm()
            self.realm!.beginWrite()
            print("begin Realm Session")
        }

    }

    func cancelRealmSession(){

        if self.realm != nil {
            if self.realm!.isInWriteTransaction == true{
                self.realm!.cancelWrite()
                print("cancel Realm Session")
            }
            self.realm = nil
        }
    }
    func commitRealmSession(){

        if self.realm != nil {
            if self.realm!.isInWriteTransaction == true{
                do{
                    try self.realm!.commitWrite()
                    print("commit Realm Session")
                    self.realm = nil
                }catch{
                    print("commit Realm Session error: \(error.localizedDescription)")
                    self.realm = nil
                }
            }
        }

    }

    
    func getDefaultRealm(block: @escaping (Realm) -> ()) {
        let queue = DispatchQueue.main
        getRealm(queue: queue, block: block)
    }
    
    func getWriteRealm(block: @escaping (Realm) -> ()) {
        let queue = DispatchQueue(label: "com.queue.realm.background")
        getRealm(queue: queue, block: block)
    }
    
    func getRealm(queue: DispatchQueue, block: @escaping (Realm) -> ()) {
        queue.async {
            autoreleasepool{
                do{
                    let realm = try Realm()
                    realm.refresh()
                    block(realm)
                }catch{
                    print("*** Archivio pieno ***")
                }
            }
        }
    }
    
    //MARK: - Proivate Funtions
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func refreshStorage(){
        
        var config = Realm.Configuration()
        
        let permission = NSNumber(value: 0o664)
        print("Reload realm file :\(config.fileURL!.absoluteString)")
         do {
            try FileManager.default.setAttributes([FileAttributeKey.posixPermissions:permission], ofItemAtPath: config.fileURL!.path)
         } catch {
            print("Error to reopen realm -> \(error.localizedDescription)")
        }

        
        config.schemaVersion = 5
        Realm.Configuration.defaultConfiguration = config
        
        do{
            let realm = try Realm(configuration: config)
            realm.refresh()
            print("Realm file :\(config.fileURL!)")
        }catch{
            print("Error to open realm -> \(error.localizedDescription)")
        }

    }


}
