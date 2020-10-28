//
//  KeyboardToolBar.swift
//  MeMo
//
//  Created by Alessandro Perna on 19/02/2019.
//  Copyright © 2019 Almaviva Spa. All rights reserved.
//

import UIKit

class KeyboardToolBar: UIToolbar {
    
    var cancelButtonPressed:(()->Void)?
    var doneButtonPressed:(()->Void)?
    var nextButtonPressed:(()->Void)?

    var isNext:Bool = false

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.barStyle = .default
        self.isTranslucent = false
        self.barStyle = .default
        self.tintColor = UIColor.darkGray
        self.isUserInteractionEnabled = true

        UIBarButtonItem.appearance().setTitleTextAttributes(
        [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .semibold),
            NSAttributedString.Key.foregroundColor : UIColor.label,
        ], for: .normal)
        
        let closeButtonItem = UIBarButtonItem(title: "Chiudi", style: .plain, target: self, action: #selector(menuCancelButtonTapped))
        let doneButtonItem = UIBarButtonItem(title: "Fatto", style: .plain, target: self, action: #selector(menuDoneButtonTapped))
        let nextButtonItem = UIBarButtonItem(title: "Avanti", style: .plain, target: self, action: #selector(menuNextButtonTapped))
        let spaceFlexibleButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let spaceFixedButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceFixedButtonItem.width = 20
        self.setItems([ closeButtonItem, spaceFlexibleButtonItem, nextButtonItem, spaceFixedButtonItem, doneButtonItem], animated: false)
        self.sizeToFit()


        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc fileprivate func menuDoneButtonTapped(){
        cancelButtonPressed?()
    }
    @objc fileprivate func menuCancelButtonTapped(){
        doneButtonPressed?()
    }
    @objc fileprivate func menuNextButtonTapped(){
        nextButtonPressed?()
    }

}
