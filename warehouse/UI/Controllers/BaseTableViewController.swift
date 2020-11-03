//
//  BaseTableViewController.swift
//  warehouse
//
//  Created by Alessandro Perna on 01/11/2020.
//

import UIKit

class BaseTableViewController: UIViewController {

    @objc func keyboardWillShowNotification(notification:Notification, rect:CGRect){}
    @objc func keyboardDidShowNotification(notification:Notification, rect:CGRect){}
    @objc func keyboardDidChangeFrameNotification(notification:Notification, rect:CGRect){}
    @objc func keyboardWillChangeFrameNotification(notification:Notification, rect:CGRect){}
    @objc func keyboardWillHideNotification(notification:Notification, rect:CGRect){}
    @objc func keyboardDidHideNotification(notification:Notification, rect:CGRect){}

    var isKeyboardNotificationEnabled = false


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //adding application notification

        //adding keyboard notification
        if isKeyboardNotificationEnabled {
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidChange(notification:)), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)

        }
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        //remove keyboard notification
        if isKeyboardNotificationEnabled {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
        }

    }

    //MARK: - Keyboard

    @objc private func keyboardWillChange(notification: Notification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardWillChangeFrameNotification(notification: notification, rect: keyboardSize)

            let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber) as? TimeInterval  ?? 0.0
            let curve: UIView.AnimationOptions = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber).map { UIView.AnimationOptions(rawValue: UInt(truncating: $0)) } ?? UIView.AnimationOptions.curveLinear

            if let constraintBottomTable = self.view.constraints.first(where: {$0.identifier == "bottomTable"}){
                constraintBottomTable.constant = -keyboardSize.size.height
            }
            
            UIView.animate(withDuration: duration, delay: 0.0, options: curve, animations: {
                self.view.setNeedsLayout()
            }, completion: nil)
        }

    }


    @objc private func keyboardWillShow(notification: Notification){

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardWillShowNotification(notification: notification, rect: keyboardSize)

            let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber) as? TimeInterval  ?? 0.0
            let curve: UIView.AnimationOptions = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber).map { UIView.AnimationOptions(rawValue: UInt(truncating: $0)) } ?? UIView.AnimationOptions.curveLinear

            if let constraintBottomTable = self.view.constraints.first(where: {$0.identifier == "bottomTable"}){
                constraintBottomTable.constant = -keyboardSize.size.height
            }

            UIView.animate(withDuration: duration, delay: 0.0, options: curve, animations: {
                self.view.setNeedsLayout()
            }, completion: nil)
        }

    }

    @objc private func keyboardWillHide(notification: Notification){

        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardWillHideNotification(notification: notification, rect: CGRect.zero)

            let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber) as? TimeInterval  ?? 0.0
            let curve: UIView.AnimationOptions = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber).map { UIView.AnimationOptions(rawValue: UInt(truncating: $0)) } ?? UIView.AnimationOptions.curveLinear

            if let constraintBottomTable = self.view.constraints.first(where: {$0.identifier == "bottomTable"}){
                constraintBottomTable.constant = 0
            }

            UIView.animate(withDuration: duration, delay: 0.0, options: curve, animations: {
                self.view.setNeedsLayout()
            }, completion: nil)

        }
    }


    @objc private func keyboardDidChange(notification: Notification) {

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardDidChangeFrameNotification(notification: notification, rect: keyboardSize)

            let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber) as? TimeInterval  ?? 0.0
            let curve: UIView.AnimationOptions = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber).map { UIView.AnimationOptions(rawValue: UInt(truncating: $0)) } ?? UIView.AnimationOptions.curveLinear

            if let constraintBottomTable = self.view.constraints.first(where: {$0.identifier == "bottomTable"}){
                constraintBottomTable.constant = -keyboardSize.size.height
            }

            UIView.animate(withDuration: duration, delay: 0.0, options: curve, animations: {
                self.view.setNeedsLayout()
            }, completion: nil)
        }

    }


    @objc private func keyboardDidShow(notification: Notification){

        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardDidShowNotification(notification: notification, rect: keyboardSize)

            let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber) as? TimeInterval  ?? 0.0
            let curve: UIView.AnimationOptions = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber).map { UIView.AnimationOptions(rawValue: UInt(truncating: $0)) } ?? UIView.AnimationOptions.curveLinear

            if let constraintBottomTable = self.view.constraints.first(where: {$0.identifier == "bottomTable"}){
                constraintBottomTable.constant = -keyboardSize.size.height
            }

            UIView.animate(withDuration: duration, delay: 0.0, options: curve, animations: {
                self.view.setNeedsLayout()
            }, completion: nil)
        }

    }

    @objc private func keyboardDidHide(notification: Notification){

        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardDidHideNotification(notification: notification, rect: CGRect.zero)

            let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber) as? TimeInterval  ?? 0.0
            let curve: UIView.AnimationOptions = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber).map { UIView.AnimationOptions(rawValue: UInt(truncating: $0)) } ?? UIView.AnimationOptions.curveLinear

            if let constraintBottomTable = self.view.constraints.first(where: {$0.identifier == "bottomTable"}){
                constraintBottomTable.constant = 0
            }

            UIView.animate(withDuration: duration, delay: 0.0, options: curve, animations: {
                self.view.setNeedsLayout()
            }, completion: nil)

        }
    }


}
