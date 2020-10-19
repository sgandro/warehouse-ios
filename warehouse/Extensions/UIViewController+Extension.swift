//
//  UIViewController+Extension.swift
//  warehouse
//
//  Created by Alessandro Perna on 18/10/2020.
//

import UIKit

extension UIViewController{

    public func showAlert(title: String, andBody body:String) {
        let alertController = UIAlertController.init(title: title, message: body, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Ok", style: .default, handler: { _ in })
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion:nil)
    }

    public func showAlert(title:String, andBody body:String, action: @escaping () -> Void) {
        let alertController = UIAlertController.init(title: title, message: body, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            action()
        })
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion:nil)
    }

    public func showAlertWithCancel(title:String, andBody body:String, action: @escaping (_ isOk : Bool) -> Void) {
        let alertController = UIAlertController.init(title: title, message: body, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { _ in
            action(true)
        })

        let cancel = UIAlertAction(title: "Annulla", style: .cancel, handler: { _ in
            action(false)
        })
        alertController.addAction(ok)
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion:nil)
    }

    public func requestAttention(to targetView: UIView, reversed: Bool = false, count: Int = 3) {
        let controlAnimator = UIViewPropertyAnimator(
            duration: 0.1, timingParameters:  UICubicTimingParameters())

        controlAnimator.addAnimations {
            var scale = reversed ? 0.9 : 1.1
            scale = count == 0 ? 1 : scale
            targetView.transform = CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale))
        }
        controlAnimator.addCompletion { _ in
            if count == 0 {
                return
            }
            self.requestAttention(to: targetView, reversed: !reversed, count: count - 1)
        }
        controlAnimator.startAnimation()
    }

}
