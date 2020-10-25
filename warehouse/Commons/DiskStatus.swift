
import UIKit

open class DiskStatus {
    
    //MARK: Formatter MB only
    class func MBFormatter(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = ByteCountFormatter.Units.useMB
        formatter.countStyle = ByteCountFormatter.CountStyle.decimal
        formatter.includesUnit = false
        return formatter.string(fromByteCount: bytes) as String
    }
    
    
    //MARK: Get String Value
    class var totalDiskSpace:String {
        get {
            return ByteCountFormatter.string(fromByteCount: totalDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
        }
    }
    
    class var freeDiskSpace:String {
        get {
            return ByteCountFormatter.string(fromByteCount: freeDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
        }
    }
    
    class var usedDiskSpace:String {
        get {
            return ByteCountFormatter.string(fromByteCount: usedDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.binary)
        }
    }
    
    
    //MARK: Get raw value
    class var totalDiskSpaceInBytes:Int64 {
        get {
            do {
                let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
                let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value
                return space!
            } catch {
                return 0
            }
        }
    }
    
    class var freeDiskSpaceInBytes:Int64 {
        get {
            do {
                let systemAttributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
                let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value
                return freeSpace!
            } catch {
                return 0
            }
        }
    }
    
    class var usedDiskSpaceInBytes:Int64 {
        get {
            let usedSpace = totalDiskSpaceInBytes - freeDiskSpaceInBytes
            return usedSpace
        }
    }
    
    
    class func isFullSpace(threshold:Int64)->Bool{
        if totalDiskSpaceInBytes <= threshold{
            return true
        }else{
            return false
        }
    }
    
    
    class func presentViewControllerFullSpace(sender:UIViewController?, alertController:UIViewController, threshold:Int64, completed:((_ spaceIsAvailable:Bool)->Void)?){
        
        if threshold == -1{
            
            if sender != nil{
                sender!.present(alertController, animated: false) {
                    completed?(false)
                }
            }else{
                UIApplication.shared.keyWindow?.rootViewController = alertController
                completed?(false)
            }
            
        }
        
        if totalDiskSpaceInBytes <= threshold{
            
            if sender != nil{
                sender!.present(alertController, animated: false) {
                    completed?(false)
                }
            }else{
                UIApplication.shared.keyWindow?.rootViewController = alertController
                completed?(false)
            }
        }else{
            completed?(true)
        }
    }
    
}
