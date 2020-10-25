//
//  MenuItemCell.swift
//  warehouse
//
//  Created by Alessandro Perna on 17/10/2020.
//

import UIKit

class MenuItemCell: UITableViewCell {

    @IBOutlet weak var labelTitle:UILabel!
    @IBOutlet weak var imageViewIcon:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear
        self.labelTitle.initializeAttributes(font: UIFont.systemFont(ofSize: 18, weight: .bold), color: UIColor.label, align: .left)
        self.imageViewIcon.tintColor = UIColor.label
        self.selectionStyle = .none
    }

    //MARK: - Class Properties

    //MARK: - Class Properties
    private class var className:String{
        return String(describing: type(of: self)).components(separatedBy: ".").first!
    }

    class var nibName: UINib  {
        get{
            return UINib(nibName: "MenuItemCell" , bundle: nil)
        }
    }

    class var identifier: String  {
        get{
            return className
        }
    }

    class var size: CGSize {
        get{
            return CGSize(width: UIScreen.main.bounds.width, height: 60)
        }
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected{
            self.labelTitle.initializeAttributes(font: UIFont.systemFont(ofSize: 18, weight: .bold), color: UIColor.label, align: .left)
        }else{
            self.labelTitle.initializeAttributes(font: UIFont.systemFont(ofSize: 18, weight: .regular), color: UIColor.label, align: .left)
        }

    }
    
}
