import Foundation
import UIKit

open class ApplicationNotifications{
    
    var foreground:((_ notification: Notification)->Void)?
    var background:((_ notification: Notification)->Void)?
    var resignActive:((_ notification: Notification)->Void)?
    var becameActive:((_ notification: Notification)->Void)?
    
    init(){
        print("ApplicationNotification Init")
    }
    func didBackgroundAndForegroundNotification(foreground:@escaping ((_ notification: Notification)->Void),
                                                background:@escaping ((_ notification: Notification)->Void)){
        
        self.foreground = foreground
        self.background = background
        
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: nil) { (notification) in
            self.foreground?(notification)
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { (notification) in
            self.background?(notification)
        }
        
        
    }
    
    func willResignActiveAndDidBecomeActiveNotification(resignActive:@escaping ((_ notification: Notification)->Void),
                                                        becameActive:@escaping ((_ notification: Notification)->Void)){
        
        self.resignActive = resignActive
        self.becameActive = becameActive
        
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: nil) { (notification) in
            self.resignActive?(notification)
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { (notification) in
            self.becameActive?(notification)
        }
        
        
    }
    
    
    deinit{
        
        NotificationCenter.default.removeObserver(self)
    }
}
