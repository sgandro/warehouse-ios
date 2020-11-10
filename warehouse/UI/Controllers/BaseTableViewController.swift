//
//  BaseTableViewController.swift
//  warehouse
//
//  Created by Alessandro Perna on 01/11/2020.
//

import UIKit

class BaseTableViewController: UIViewController {

    @objc func notificationWillEnterForeground(notification:Notification){}
    @objc func notificationDidEnterBackground(notification:Notification){}
    @objc func notificationWillResignActive(notification:Notification){}
    @objc func notificationDidBecomeActive(notification:Notification){}

    @objc func keyboardWillShowNotification(notification:Notification, rect:CGRect){}
    @objc func keyboardDidShowNotification(notification:Notification, rect:CGRect){}
    @objc func keyboardDidChangeFrameNotification(notification:Notification, rect:CGRect){}
    @objc func keyboardWillChangeFrameNotification(notification:Notification, rect:CGRect){}
    @objc func keyboardWillHideNotification(notification:Notification, rect:CGRect){}
    @objc func keyboardDidHideNotification(notification:Notification, rect:CGRect){}

    var isKeyboardNotificationEnabled = false
    var isApplicationNotificationEnabled = false


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //adding application notification
        if isApplicationNotificationEnabled {
            NotificationCenter.default.addObserver(self, selector: #selector(self.notificationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.notificationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.notificationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.notificationDidBecomeActive(notification:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        }
        //adding keyboard notification
        if isKeyboardNotificationEnabled {
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        }
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        //remove application notification
        if isApplicationNotificationEnabled {
            NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        }
        //remove keyboard notification
        if isKeyboardNotificationEnabled {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        }


    }

    //MARK: - Keyboard

    @objc private func keyboardWillChange(notification: Notification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

            let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber) as? TimeInterval  ?? 0.0
            let curve: UIView.AnimationOptions = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber).map { UIView.AnimationOptions(rawValue: UInt(truncating: $0)) } ?? UIView.AnimationOptions.curveLinear

            keyboardWillChangeFrameNotification(notification: notification, rect: keyboardSize)

            UIView.animate(withDuration: duration, delay: 0.0, options: curve, animations: {
                self.view.setNeedsLayout()
            }, completion: nil)
        }

    }


    @objc private func keyboardWillShow(notification: Notification){

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

            let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber) as? TimeInterval  ?? 0.0
            let curve: UIView.AnimationOptions = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber).map { UIView.AnimationOptions(rawValue: UInt(truncating: $0)) } ?? UIView.AnimationOptions.curveLinear

            keyboardWillShowNotification(notification: notification, rect: keyboardSize)

            UIView.animate(withDuration: duration, delay: 0.0, options: curve, animations: {
                self.view.setNeedsLayout()
            }, completion: nil)
        }

    }

    @objc private func keyboardWillHide(notification: Notification){

        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

            let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber) as? TimeInterval  ?? 0.0
            let curve: UIView.AnimationOptions = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber).map { UIView.AnimationOptions(rawValue: UInt(truncating: $0)) } ?? UIView.AnimationOptions.curveLinear

            keyboardWillHideNotification(notification: notification, rect: CGRect.zero)

            UIView.animate(withDuration: duration, delay: 0.0, options: curve, animations: {
                self.view.setNeedsLayout()
            }, completion: nil)

        }
    }


    @objc private func keyboardDidChange(notification: Notification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

            let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber) as? TimeInterval  ?? 0.0
            let curve: UIView.AnimationOptions = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber).map { UIView.AnimationOptions(rawValue: UInt(truncating: $0)) } ?? UIView.AnimationOptions.curveLinear

            keyboardDidChangeFrameNotification(notification: notification, rect: keyboardSize)

            UIView.animate(withDuration: duration, delay: 0.0, options: curve, animations: {
                self.view.setNeedsLayout()
            }, completion: nil)
        }

    }


    @objc private func keyboardDidShow(notification: Notification){

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

            let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber) as? TimeInterval  ?? 0.0
            let curve: UIView.AnimationOptions = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber).map { UIView.AnimationOptions(rawValue: UInt(truncating: $0)) } ?? UIView.AnimationOptions.curveLinear

            keyboardDidShowNotification(notification: notification, rect: keyboardSize)

            UIView.animate(withDuration: duration, delay: 0.0, options: curve, animations: {
                self.view.setNeedsLayout()
            }, completion: nil)
        }

    }

    @objc private func keyboardDidHide(notification: Notification){

        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

            let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber) as? TimeInterval  ?? 0.0
            let curve: UIView.AnimationOptions = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber).map { UIView.AnimationOptions(rawValue: UInt(truncating: $0)) } ?? UIView.AnimationOptions.curveLinear

            keyboardDidHideNotification(notification: notification, rect: CGRect.zero)

            UIView.animate(withDuration: duration, delay: 0.0, options: curve, animations: {
                self.view.setNeedsLayout()
            }, completion: nil)

        }
    }


}
