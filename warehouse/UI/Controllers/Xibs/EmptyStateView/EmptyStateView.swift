//
//  EmptyStateView.swift
//  warehouse
//
//  Created by Alessandro Perna on 18/10/2020.
//

import UIKit

class EmptyStateView: UIView {

    @IBOutlet weak var contentView:UIView!
    @IBOutlet weak var labelMessage: UILabel!
    

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
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        labelMessage.initializeAttributes(font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.semibold), color: UIColor.darkGray, align: .center)
    }


}
