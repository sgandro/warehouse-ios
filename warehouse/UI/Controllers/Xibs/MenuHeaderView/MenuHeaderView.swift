//
//  MenuHeaderView.swift
//  warehouse
//
//  Created by Alessandro Perna on 17/10/2020.
//

import UIKit

class MenuHeaderView: UIView {

    @IBOutlet weak var contentView:UIView!
    @IBOutlet weak var lblTitle:UILabel!

    static var height: CGFloat = 80.0

    //MARK: - Class Properties
    private var className:String{
        return String(describing: type(of: self)).components(separatedBy: ".").first!
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        settings()

    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        settings()
    }


    private func settings(){
        Bundle.main.loadNibNamed(className, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.backgroundColor = UIColor.clear
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        lblTitle.textColor = UIColor.label

    }


}
