
import Foundation
import UIKit

open class BaseViewController: UIViewController {
    
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
    

    //MARK: - ViewCicle
    
    open override func viewDidLoad() {
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
            keyboardWillChangeFrameNotification(notification: notification, rect: keyboardSize)
            
            let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber) as? TimeInterval  ?? 0.0
            let curve: UIView.AnimationOptions = (notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber).map { UIView.AnimationOptions(rawValue: UInt(truncating: $0)) } ?? UIView.AnimationOptions.curveLinear
            
            if let scrollView = self.view as? UIScrollView{
                var height:CGFloat = 0
                if let tabbar = self.tabBarController?.tabBar.frame.height, self.tabBarController?.tabBar.isHidden == false {
                    height = keyboardSize.size.height - tabbar
                } else {
                    height = keyboardSize.size.height
                }
                //let height = keyboardSize.size.height - (self.tabBarController?.tabBar.frame.height ?? 0)
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
                //scrollView.contentOffset = CGPoint(x: 0, y: height)
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
            
            if let scrollView = self.view as? UIScrollView{
                var height:CGFloat = 0
                if let tabbar = self.tabBarController?.tabBar.frame.height, self.tabBarController?.tabBar.isHidden == false {
                    height = keyboardSize.size.height - tabbar
                } else {
                    height = keyboardSize.size.height
                }
                // let height = keyboardSize.size.height - (self.tabBarController?.tabBar.frame.height ?? 0)
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: height, right: 0)
                //scrollView.contentOffset = CGPoint(x: 0, y: height)
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
            
            if let scrollView = self.view as? UIScrollView{
                scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            }
            
            UIView.animate(withDuration: duration, delay: 0.0, options: curve, animations: {
                self.view.setNeedsLayout()
            }, completion: nil)
            
        }
    }
    
    // MARK: - Views

    func goToHome(){
        self.performSegue(withIdentifier: "goToHome", sender: nil)
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

