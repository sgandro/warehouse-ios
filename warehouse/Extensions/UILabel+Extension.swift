//
//  UILabel+Extension.swift
//  warehouse
//
//  Created by Alessandro Perna on 17/10/2020.
//

import UIKit

extension UILabel{
    func initialize(textValue:String? = "", font:UIFont = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular), color:UIColor = .darkGray, align: NSTextAlignment = .left){
        self.text = textValue
        initializeAttributes(font: font, color: color, align: align)
    }

    func initializeAttributes(font:UIFont = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular), color:UIColor = .darkGray, align: NSTextAlignment = .left){
        self.font = font
        self.textColor = color
        self.textAlignment = align
    }
}
