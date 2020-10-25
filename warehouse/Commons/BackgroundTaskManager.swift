//
//  BackgroundTaskManager.swift
//  Old industrial barber shop
//
//  Created by Alessandro Perna on 29/05/2020.
//  Copyright © 2020 AlePerna. All rights reserved.
//

import UIKit

class BackgroundTaskManager {
    let backgroundDQ = DispatchQueue.global(qos: .background)
    var backgroundUpdateTask: UIBackgroundTaskIdentifier!

    init(withName: String) {

        self.backgroundUpdateTask = UIApplication.shared.beginBackgroundTask(withName: withName) {}
    }

    /* Using completion handler to know when code is done*/
    func runBackgroundTask(withCode: @escaping (_ cH: @escaping () -> Void) -> Void)
    {
        backgroundDQ.async {
            withCode() {
                self.endBackgroungTask()
            }
        }
    }

    func endBackgroungTask() {
        if backgroundUpdateTask != nil && backgroundUpdateTask != UIBackgroundTaskIdentifier.invalid {
            UIApplication.shared.endBackgroundTask(backgroundUpdateTask)
            backgroundUpdateTask = UIBackgroundTaskIdentifier.invalid
        }
    }
}
