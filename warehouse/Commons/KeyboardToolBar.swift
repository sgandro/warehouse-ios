//
//  KeyboardToolBar.swift
//  MeMo
//
//  Created by Alessandro Perna on 19/02/2019.
//  Copyright © 2019 Almaviva Spa. All rights reserved.
//

import UIKit

class KeyboardToolBar: UIToolbar {
    
    var closeButtonPressed:(()->Void)?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.barStyle = .default
        self.isTranslucent = false
        self.barStyle = .default
        self.tintColor = UIColor.darkGray
        self.isUserInteractionEnabled = true
        
        if let image = UIImage(named: "close-keyboard"){
            let closeButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(menuButtonTapped))
            closeButtonItem.image = image
            let spaceButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
            self.setItems([ spaceButtonItem, closeButtonItem ], animated: false)
            self.sizeToFit()

        }else{
            let closeButtonItem = UIBarButtonItem(title: "Chiudi", style: .plain, target: self, action: #selector(menuButtonTapped))
            let spaceButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
            self.setItems([ spaceButtonItem, closeButtonItem ], animated: false)
            self.sizeToFit()

        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc fileprivate func menuButtonTapped(){
        closeButtonPressed?()
    }
    
}
