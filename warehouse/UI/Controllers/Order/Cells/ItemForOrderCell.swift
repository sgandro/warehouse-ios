//
//  ItemForOrderCell.swift
//  warehouse
//
//  Created by Alessandro Perna on 07/11/2020.
//

import UIKit
import RealmSwift

class ItemForOrderCell: UITableViewCell {

    @IBOutlet weak var labelName:UILabel!

    @IBOutlet weak var labelCaptionUnit:UILabel!
    @IBOutlet weak var labelUnit:UILabel!

    @IBOutlet weak var labelCaptionQuantity:UILabel!
    @IBOutlet weak var labelQuantity:UILabel!

    @IBOutlet weak var labelCaptionPrice:UILabel!
    @IBOutlet weak var labelPrice:UILabel!

    @IBOutlet weak var labelCaptionMinStock:UILabel!
    @IBOutlet weak var labelMinStock:UILabel!

    @IBOutlet weak var labelCaptionOrder:UILabel!
    @IBOutlet weak var labelOrder:UILabel!

    var item:Item?{
        didSet{
            labelName.text = item?.name
            labelUnit.text = item?.unit
            labelQuantity.text = "\(item?.quantity ?? 0)"
            labelPrice.text = "\(item?.price ?? 0.0) €"
            labelMinStock.text = "\(item?.minimumStock ?? 0)"
            labelOrder.text = "\(item?.inOrder ?? 0)"
        }
    }

    var updateOrder:((_ item:Item?)->Void)?

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
            return CGSize(width: UIScreen.main.bounds.width, height: 60)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none

        labelName.initialize(textValue: item?.name,
                             font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold),
                             color: UIColor.label,
                             align: .left)

        labelCaptionUnit.initialize(textValue: "Unità",
                                    font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular),
                                    color: UIColor.label,
                                    align: .left)

        labelUnit.initialize(textValue: item?.unit.trimmingCharacters(in: .whitespaces),
                             font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold),
                             color: UIColor.label,
                             align: .left)

        labelCaptionQuantity.initialize(textValue: "In Cambusa",
                                        font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular),
                                        color: UIColor.label,
                                        align: .right)

        labelQuantity.initialize(textValue: "\(item?.quantity ?? 0)",
                                 font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold),
                                 color: UIColor.label,
                                 align: .right)

        labelCaptionPrice.initialize(textValue: "Prezzo",
                                     font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular),
                                     color: UIColor.label,
                                     align: .left)

        labelPrice.initialize(textValue: "\(item?.price ?? 0.0)€",
                              font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold),
                              color: UIColor.label,
                              align: .left)

        labelCaptionMinStock.initialize(textValue: "Scorta min.",
                                        font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular),
                                        color: UIColor.label,
                                        align: .right)
        
        labelMinStock.initialize(textValue: "\(item?.minimumStock ?? 0)",
                                 font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold),
                                 color: UIColor.label,
                                 align: .right)


        labelCaptionOrder.initialize(textValue: "Ordina",
                                        font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular),
                                        color: UIColor.label,
                                        align: .left)

        labelOrder.initialize(textValue: "\(item?.inOrder ?? 0)",
                                 font: UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold),
                                 color: UIColor.label,
                                 align: .center)


    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    @IBAction func addButtonPressed(button:UIButton){
        if item != nil {
            item!.inOrder += 1
            updateOrder?(item)
            labelOrder.text = "\(item?.inOrder ?? 0)"
        }
    }

    @IBAction func lessButtonPressed(button:UIButton){
        if item != nil {
            item!.inOrder -= 1
            if item!.inOrder < 1 {
                item!.inOrder = 0
                updateOrder?(item)
            }
            labelOrder.text = "\(item?.inOrder ?? 0)"

        }
    }

}
