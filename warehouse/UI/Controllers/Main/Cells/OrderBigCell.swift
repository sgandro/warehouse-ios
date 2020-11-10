//
//  OrderBigCell.swift
//  warehouse
//
//  Created by Alessandro Perna on 03/11/2020.
//

import UIKit

class OrderBigCell: UICollectionViewCell {

    @IBOutlet weak var labelTitle:UILabel!
    @IBOutlet weak var imageView:UIImageView!

    //MARK: - Class Properties
    private class var className:String{
        return String(describing: type(of: self)).components(separatedBy: ".").first!
    }

    class var nibName: UINib  {
        get{
            return UINib(nibName: className , bundle: nil)
        }
    }

    class var identifier: String  {
        get{
            return className
        }
    }

    class var size: CGSize {
        get{
            return CGSize(width: 128, height: 128)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.darkGray.cgColor


        labelTitle.initialize(textValue: "",
                              font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold),
                              color: UIColor.label,
                              align: .center)

    }


    override var isSelected: Bool{
        didSet{
            if isSelected {
                self.layer.borderWidth = 2.0
                self.layer.borderColor = UIColor.label.cgColor
            }else{
                self.layer.borderWidth = 0.5
                self.layer.borderColor = UIColor.darkGray.cgColor
            }
        }

    }

    override func prepareForReuse() {
        isSelected = false
        labelTitle.text = nil
        imageView.image = nil
    }
}
