//
//  AddHeaderView.swift
//  warehouse
//
//  Created by Alessandro Perna on 30/10/2020.
//

import UIKit

protocol AddHeaderViewDelegte {
    func addHeaderViewDidButtonPressed(field:[String:Any]?)
}
class AddHeaderView: UIView {

    @IBOutlet weak var contentView:UIView!
    @IBOutlet weak var labelCaption:UILabel!
    
    var delegate: AddHeaderViewDelegte?
    var field:[String:Any]?
    static let hight: CGFloat = 60.0

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

        labelCaption.initializeAttributes(font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                                          color: UIColor.secondaryLabel,
                                          align: .left)
    }

    @IBAction func addButtonPressed(button:UIButton){
        delegate?.addHeaderViewDidButtonPressed(field: field)
    }

}
