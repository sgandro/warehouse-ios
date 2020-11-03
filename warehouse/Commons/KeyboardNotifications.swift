//
//  KeyboardNotification.swift
//  warehouse
//
//  Created by Alessandro Perna on 01/11/2020.
//

import Foundation
import UIKit

open class KeyboardNotifications{

    var willShow:((_ notification: Notification)->Void)?
    var didShow:((_ notification: Notification)->Void)?
    var willChange:((_ notification: Notification)->Void)?
    var didChange:((_ notification: Notification)->Void)?
    var willHide:((_ notification: Notification)->Void)?
    var didHide:((_ notification: Notification)->Void)?


    init(){
        print("KeyboardNotifications Init")
    }

    func keyboardWillShowNotification(willShow:@escaping ((_ notification: Notification)->Void)){
        self.willShow = willShow
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                               object: nil,
                                               queue: nil) { (notification) in
                                                    self.willShow?(notification)
                                                }
    }

    func keyboardDidShowNotification(didShow:@escaping ((_ notification: Notification)->Void)){
        self.didShow = didShow
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification,
                                               object: nil,
                                               queue: nil) { (notification) in
                                                    self.didShow?(notification)
                                                }
    }

    func keyboardDidChangeFrameNotification(didChange:@escaping ((_ notification: Notification)->Void)){
        self.didChange = didChange
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidChangeFrameNotification,
                                               object: nil,
                                               queue: nil) { (notification) in
                                                    self.didChange?(notification)
                                                }
    }

    func keyboardWillChangeFrameNotification(willChange:@escaping ((_ notification: Notification)->Void)){
        self.willChange = willChange
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil,
                                               queue: nil) { (notification) in
                                                    self.willChange?(notification)
                                                }
    }

    func keyboardWillHideNotification(willHide:@escaping ((_ notification: Notification)->Void)){
        self.willHide = willHide
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                               object: nil,
                                               queue: nil) { (notification) in
                                                    self.willHide?(notification)
                                                }
    }

    func keyboardDidHideNotification(didHide:@escaping ((_ notification: Notification)->Void)){
        self.didHide = didHide
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification,
                                               object: nil,
                                               queue: nil) { (notification) in
                                                    self.didHide?(notification)
                                                }
    }

    deinit{

        NotificationCenter.default.removeObserver(self)
    }
}
