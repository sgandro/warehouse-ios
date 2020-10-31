//
//  DataEntryTextFiledCell.swift
//  warehouse
//
//  Created by Alessandro Perna on 29/10/2020.
//

import UIKit

protocol PickerDataEntryTextFiledCellDelegate {
    func pickerDataEntryTextFiledDidSelected(cell:PickerDataEntryTextFiledCell, value: String?)
}

class PickerDataEntryTextFiledCell: UITableViewCell {

    @IBOutlet weak var labelCaption:UILabel!
    @IBOutlet weak var pickerTextView:PickerTextView!

    var caption:String?{
        didSet{
            labelCaption.text = caption
        }
    }
    var delegate: PickerDataEntryTextFiledCellDelegate?
    var indexPath:IndexPath?
    var fieldInfo:[String:Any]?



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
            return CGSize(width: UIScreen.main.bounds.width, height: 72)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none

        labelCaption.initializeAttributes(font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                          color: UIColor.secondaryLabel,
                                          align: .left)

        pickerTextView.pickerItemSelected = { (done, value) in
            self.delegate?.pickerDataEntryTextFiledDidSelected(cell:self, value: value)
        }


    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

