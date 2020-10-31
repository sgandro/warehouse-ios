//
//  DataEntryTextFiledCell.swift
//  warehouse
//
//  Created by Alessandro Perna on 29/10/2020.
//

import UIKit

protocol DataEntryPhoneCellDelegate {
    func dataEntryPhoneCellDidNext(cell:DataEntryPhoneCell)
    func dataEntryPhoneCellDidCheck(cell:DataEntryPhoneCell)
    func dataEntryPhoneCellDidKeyboardDone(cell:DataEntryPhoneCell)
    func dataEntryPhoneCellDidKeyboardCancel(cell:DataEntryPhoneCell)
    func dataEntryPhoneCellDidKeyboardNext(cell:DataEntryPhoneCell)
}
class DataEntryPhoneCell: UITableViewCell {

    @IBOutlet weak var labelTitleCaption:UILabel!
    @IBOutlet weak var textTitleField:UITextField!
    @IBOutlet weak var labelNumberCaption:UILabel!
    @IBOutlet weak var textNumberField:UITextField!


    var captionTitle:String?{
        didSet{
            labelTitleCaption.text = captionTitle
        }
    }

    var captionNumber:String?{
        didSet{
            labelNumberCaption.text = captionNumber
        }
    }

    var delegate: DataEntryPhoneCellDelegate?
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
        labelTitleCaption.initializeAttributes(font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                               color: UIColor.secondaryLabel,
                                               align: .left)

        labelNumberCaption.initializeAttributes(font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                                color: UIColor.secondaryLabel,
                                                align: .left)

        let keyboardToolBar = KeyboardToolBar()
        keyboardToolBar.nextButtonPressed = {
            self.delegate?.dataEntryPhoneCellDidNext(cell: self)
        }
        keyboardToolBar.doneButtonPressed = {
            self.delegate?.dataEntryPhoneCellDidKeyboardDone(cell: self)
        }
        keyboardToolBar.cancelButtonPressed = {
            self.delegate?.dataEntryPhoneCellDidKeyboardCancel(cell: self)
        }

        textTitleField.inputAccessoryView = keyboardToolBar
        textNumberField.inputAccessoryView = keyboardToolBar
        textTitleField.delegate = self
        textNumberField.delegate = self

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension DataEntryPhoneCell: UITextFieldDelegate{

    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.dataEntryPhoneCellDidCheck(cell: self)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.dataEntryPhoneCellDidNext(cell: self)
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !string.isEmpty{
            delegate?.dataEntryPhoneCellDidCheck(cell: self)
        }
        return true
    }


}
