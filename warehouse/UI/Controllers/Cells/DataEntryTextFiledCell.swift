//
//  DataEntryTextFiledCell.swift
//  warehouse
//
//  Created by Alessandro Perna on 29/10/2020.
//

import UIKit

protocol DataEntryTextFiledCellDelegate {
    func dataEntryTextFiledDidNext(cell:DataEntryTextFiledCell)
    func dataEntryTextFiledDidCheck(cell:DataEntryTextFiledCell)
    func dataEntryTextFiledDidKeyboardDone(cell:DataEntryTextFiledCell)
    func dataEntryTextFiledDidKeyboardCancel(cell:DataEntryTextFiledCell)
    func dataEntryTextFiledDidKeyboardNext(cell:DataEntryTextFiledCell)
}
class DataEntryTextFiledCell: UITableViewCell {

    @IBOutlet weak var labelCaption:UILabel!
    @IBOutlet weak var textFieldValue:UITextField!

    var caption:String?{
        didSet{
            labelCaption.text = caption
        }
    }
    var delegate: DataEntryTextFiledCellDelegate?
    var indexPath:IndexPath?
    var keyboardType:UIKeyboardType?{
        didSet{
            textFieldValue.keyboardType = keyboardType ?? .default
        }
    }
    var fieldInfo:[String:Any]?

    private let formatter: NumberFormatter = {
        let frm = NumberFormatter()
        frm.locale = Locale(identifier: "it_IT")
        frm.minimumIntegerDigits = 1
        frm.maximumIntegerDigits = 2
        return frm
    }()


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
        textFieldValue.delegate = self

        labelCaption.initializeAttributes(font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                          color: UIColor.secondaryLabel,
                                          align: .left)

        let keyboardToolBar = KeyboardToolBar()
        keyboardToolBar.nextButtonPressed = {
            self.delegate?.dataEntryTextFiledDidKeyboardNext(cell: self)
        }
        keyboardToolBar.doneButtonPressed = {
            self.delegate?.dataEntryTextFiledDidKeyboardDone(cell: self)
        }
        keyboardToolBar.cancelButtonPressed = {
            self.delegate?.dataEntryTextFiledDidKeyboardCancel(cell: self)
        }

        textFieldValue.inputAccessoryView = keyboardToolBar

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension DataEntryTextFiledCell: UITextFieldDelegate{

    func textFieldDidEndEditing(_ textField: UITextField) {

        guard let format = self.fieldInfo?["format"] as? String else {
            return
        }

        switch format {
            case "currency":
                self.formatter.numberStyle = .currency
                if
                    let text = textField.text?.replacingOccurrences(of: ",", with: "."),
                    let doubleValue = Double(text)
                {
                    textField.text = formatter.string(from: NSNumber(value: doubleValue))
                }else{
                    //TODO: Gestione validazione
                }
            case "percent":
                self.formatter.numberStyle = .percent
                if
                    let text = textField.text,
                    let doubleValue = Double(text)
                {
                    textField.text = formatter.string(from: NSNumber(value: doubleValue / 100.0))
                }else{
                    //TODO: Gestione validazione
                }
            case "integer":
                self.formatter.numberStyle = .none
                if
                    let text = textField.text,
                    let integerValue = Int(text)
                {
                    textField.text = formatter.string(from: NSNumber(value: integerValue))
                }else{
                    //TODO: Gestione validazione
                }
            case "decimal":
                self.formatter.numberStyle = .decimal
                labelCaption.text = caption
            default:
                labelCaption.text = caption
        }
        delegate?.dataEntryTextFiledDidCheck(cell: self)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.dataEntryTextFiledDidNext(cell: self)
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("string:\(string)")
        if !string.isEmpty{
            delegate?.dataEntryTextFiledDidCheck(cell: self)
        }
        return true
    }


}
