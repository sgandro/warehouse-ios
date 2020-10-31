//
//  DataEntryTextFiledCell.swift
//  warehouse
//
//  Created by Alessandro Perna on 29/10/2020.
//

import UIKit

protocol DataEntryAddressCellDelegate {
    func dataEntryAddressCellDidNext(cell:DataEntryAddressCell)
    func dataEntryAddressCellDidCheck(cell:DataEntryAddressCell)
    func dataEntryAddressCellDidKeyboardDone(cell:DataEntryAddressCell)
    func dataEntryAddressCellDidKeyboardCancel(cell:DataEntryAddressCell)
    func dataEntryAddressCellDidKeyboardNext(cell:DataEntryAddressCell)
}
class DataEntryAddressCell: UITableViewCell {

    @IBOutlet weak var labelTypeCaption:UILabel!
    @IBOutlet weak var textTypeField:UITextField!

    @IBOutlet weak var labelAddressCaption:UILabel!
    @IBOutlet weak var textAddressField:UITextField!

    @IBOutlet weak var labelZipCodeCaption:UILabel!
    @IBOutlet weak var textZipCodeField:UITextField!

    @IBOutlet weak var labelCityCaption:UILabel!
    @IBOutlet weak var textCityField:UITextField!

    @IBOutlet weak var labelLocationCaption:UILabel!
    @IBOutlet weak var textLocationField:UITextField!


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

    var captionZipCode:String?{
        didSet{
            labelZipCodeCaption.text = captionZipCode
        }
    }

    var captionCity:String?{
        didSet{
            labelCityCaption.text = captionCity
        }
    }

    var captionLocation:String?{
        didSet{
            labelLocationCaption.text = captionLocation
        }
    }

    var delegate: DataEntryAddressCellDelegate?
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
            return CGSize(width: UIScreen.main.bounds.width, height: 293)
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

        labelZipCodeCaption.initializeAttributes(font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                                 color: UIColor.secondaryLabel,
                                                 align: .left)

        labelCityCaption.initializeAttributes(font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                              color: UIColor.secondaryLabel,
                                              align: .left)

        labelLocationCaption.initializeAttributes(font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                                  color: UIColor.secondaryLabel,
                                                  align: .left)
        
        let keyboardToolBar = KeyboardToolBar()
        keyboardToolBar.nextButtonPressed = {
            self.delegate?.dataEntryAddressCellDidNext(cell: self)
        }
        keyboardToolBar.doneButtonPressed = {
            self.delegate?.dataEntryAddressCellDidKeyboardDone(cell: self)
        }
        keyboardToolBar.cancelButtonPressed = {
            self.delegate?.dataEntryAddressCellDidKeyboardCancel(cell: self)
        }

        textTypeField.inputAccessoryView = keyboardToolBar
        textTypeField.delegate = self

        textAddressField.inputAccessoryView = keyboardToolBar
        textAddressField.delegate = self

        textCityField.inputAccessoryView = keyboardToolBar
        textCityField.delegate = self

        textZipCodeField.inputAccessoryView = keyboardToolBar
        textZipCodeField.delegate = self

        textLocationField.inputAccessoryView = keyboardToolBar
        textLocationField.delegate = self

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension DataEntryAddressCell: UITextFieldDelegate{

    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.dataEntryAddressCellDidCheck(cell: self)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.dataEntryAddressCellDidNext(cell: self)
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if !string.isEmpty{
            delegate?.dataEntryAddressCellDidCheck(cell: self)
        }
        return true
    }


}
