//
//  DataEntryTextFiledCell.swift
//  warehouse
//
//  Created by Alessandro Perna on 29/10/2020.
//

import UIKit

protocol DataEntryEmailCellDelegate {
    func dataEntryEmailCellDidNext(cell:DataEntryEmailCell)
    func dataEntryEmailCellDidCheck(cell:DataEntryEmailCell)
    func dataEntryEmailCellDidKeyboardDone(cell:DataEntryEmailCell)
    func dataEntryEmailCellDidKeyboardCancel(cell:DataEntryEmailCell)
    func dataEntryEmailCellDidKeyboardNext(cell:DataEntryEmailCell)
}
class DataEntryEmailCell: UITableViewCell {

    @IBOutlet weak var labelTypeCaption:UILabel!
    @IBOutlet weak var textTypeField:UITextField!
    @IBOutlet weak var labelAddressCaption:UILabel!
    @IBOutlet weak var textAddressField:UITextField!


    var captionType:String?{
        didSet{
            labelTypeCaption.text = captionType
        }
    }

    var captionAddress:String?{
        didSet{
            labelAddressCaption.text = captionAddress
        }
    }

    var delegate: DataEntryEmailCellDelegate?
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
            return CGSize(width: UIScreen.main.bounds.width, height: 125.0)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        backgroundColor = UIColor.systemGray5
        labelTypeCaption.initializeAttributes(font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                               color: UIColor.secondaryLabel,
                                               align: .left)

        labelAddressCaption.initializeAttributes(font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                                color: UIColor.secondaryLabel,
                                                align: .left)

        let keyboardToolBar = KeyboardToolBar()
        keyboardToolBar.nextButtonPressed = {
            self.delegate?.dataEntryEmailCellDidNext(cell: self)
        }
        keyboardToolBar.doneButtonPressed = {
            self.delegate?.dataEntryEmailCellDidKeyboardDone(cell: self)
        }
        keyboardToolBar.cancelButtonPressed = {
            self.delegate?.dataEntryEmailCellDidKeyboardCancel(cell: self)
        }

        textTypeField.inputAccessoryView = keyboardToolBar
        textTypeField.delegate = self
        textAddressField.inputAccessoryView = keyboardToolBar
        textAddressField.delegate = self

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension DataEntryEmailCell: UITextFieldDelegate{

    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.dataEntryEmailCellDidCheck(cell: self)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.dataEntryEmailCellDidNext(cell: self)
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !string.isEmpty{
            delegate?.dataEntryEmailCellDidCheck(cell: self)
        }
        return true
    }


}
