//
//  DataEntryTextFiledCell.swift
//  warehouse
//
//  Created by Alessandro Perna on 29/10/2020.
//

import UIKit

protocol DataEntryBankCellDelegate {
    func dataEntryBankCellDidNext(cell:DataEntryBankCell)
    func dataEntryBankCellDidCheck(cell:DataEntryBankCell)
    func dataEntryBankCellDidKeyboardDone(cell:DataEntryBankCell)
    func dataEntryBankCellDidKeyboardCancel(cell:DataEntryBankCell)
    func dataEntryBankCellDidKeyboardNext(cell:DataEntryBankCell)
}
class DataEntryBankCell: UITableViewCell {

    @IBOutlet weak var labelNameCaption:UILabel!
    @IBOutlet weak var textNameField:UITextField!

    @IBOutlet weak var labelIbanCaption:UILabel!
    @IBOutlet weak var textIbanField:UITextField!

    @IBOutlet weak var labelSwiftCaption:UILabel!
    @IBOutlet weak var textSwiftField:UITextField!

    @objc dynamic var swift: String = ""

    var captionName:String?{
        didSet{
            labelNameCaption.text = captionName
        }
    }

    var captionIban:String?{
        didSet{
            labelIbanCaption.text = captionIban
        }
    }

    var captionSwiftCode:String?{
        didSet{
            labelSwiftCaption.text = captionSwiftCode
        }
    }


    var delegate: DataEntryBankCellDelegate?
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
            return CGSize(width: UIScreen.main.bounds.width, height: 181)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        backgroundColor = UIColor.systemGray5
        labelNameCaption.initializeAttributes(font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                              color: UIColor.secondaryLabel,
                                              align: .left)

        labelIbanCaption.initializeAttributes(font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                                 color: UIColor.secondaryLabel,
                                                 align: .left)

        labelSwiftCaption.initializeAttributes(font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                                 color: UIColor.secondaryLabel,
                                                 align: .left)


        let keyboardToolBar = KeyboardToolBar()
        keyboardToolBar.nextButtonPressed = {
            self.delegate?.dataEntryBankCellDidNext(cell: self)
        }
        keyboardToolBar.doneButtonPressed = {
            self.delegate?.dataEntryBankCellDidKeyboardDone(cell: self)
        }
        keyboardToolBar.cancelButtonPressed = {
            self.delegate?.dataEntryBankCellDidKeyboardCancel(cell: self)
        }

        textNameField.inputAccessoryView = keyboardToolBar
        textNameField.delegate = self

        textIbanField.inputAccessoryView = keyboardToolBar
        textIbanField.delegate = self

        textSwiftField.inputAccessoryView = keyboardToolBar
        textSwiftField.delegate = self

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension DataEntryBankCell: UITextFieldDelegate{

    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.dataEntryBankCellDidCheck(cell: self)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.dataEntryBankCellDidNext(cell: self)
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !string.isEmpty{
            delegate?.dataEntryBankCellDidCheck(cell: self)
        }
        return true
    }


}
