//
//  PhoneView.swift
//  warehouse
//
//  Created by Alessandro Perna on 29/10/2020.
//

import UIKit
import RealmSwift

protocol PhoneViewDelegate {
    func phoneDataEntryDidDone(view: UIView, phone: [String:Any])
}
class PhoneView: UIView {

    @IBOutlet weak var labelCaptionType:UILabel!
    @IBOutlet weak var textFieldType:UITextField!

    @IBOutlet weak var labelCaptionNumber:UILabel!
    @IBOutlet weak var textFieldNumber:UITextField!

    @IBOutlet weak var contentView:UIView!
    private let keyboardToolBar = KeyboardToolBar()

    var delegate: PhoneViewDelegate?
    var phoneToUpdate:Phone?
    private var phone:[String:Any]?

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
        labelCaptionType.initialize(textValue: "Tipolgia",
                                    font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                    color: UIColor.secondaryLabel,
                                    align: .left)


        labelCaptionNumber.initialize(textValue: "Numero",
                                    font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                    color: UIColor.secondaryLabel,
                                    align: .left)

        keyboardToolBar.nextButtonPressed = {
            self.nextFieldMove()
        }
        keyboardToolBar.doneButtonPressed = {
            if self.phone != nil {
                self.delegate?.phoneDataEntryDidDone(view: self, phone: self.phone!)
            }
        }
        keyboardToolBar.cancelButtonPressed = {
            if self.phone != nil {
                self.delegate?.phoneDataEntryDidDone(view: self, phone: self.phone!)
            }
        }

        if let phoneToUpdate = self.phoneToUpdate{

            textFieldType.delegate = self
            textFieldType.returnKeyType = .next
            textFieldType.text = phoneToUpdate.type
            textFieldType.inputAccessoryView = keyboardToolBar

            textFieldNumber.delegate = self
            textFieldNumber.returnKeyType = .next
            textFieldNumber.text = phoneToUpdate.number
            textFieldNumber.inputAccessoryView = keyboardToolBar

        }else{

            textFieldType.delegate = self
            textFieldType.returnKeyType = .next
            textFieldType.inputAccessoryView = keyboardToolBar

            textFieldNumber.delegate = self
            textFieldNumber.returnKeyType = .next
            textFieldNumber.inputAccessoryView = keyboardToolBar
        }

//        self.contentView.heightAnchor.constraint(equalTo: .infinity, multiplier: 1.0, constant: 120)

    }




}
extension PhoneView:UITextFieldDelegate{

    func textFieldDidEndEditing(_ textField: UITextField) {
        checkFields(textField)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextFieldMove()
        return true
    }

    private func nextFieldMove(){

        let fields: [UITextField] = [textFieldType,
                                     textFieldNumber]

        if
            let activeField: UITextField = fields.first(where: { $0.isFirstResponder }),
            let index: Int = fields.firstIndex(of: activeField)
        {
            let lastIndex = (index < (fields.count - 1)) ? index:(fields.count - 2)
            let nextField: UITextField = fields[fields.index(after: lastIndex)]
            nextField.becomeFirstResponder()
        }

    }

    func checkFields(_ textField: UITextField){

        if textField == textFieldType {
            phone?["type"] = textField.text
        }
        if textField == textFieldNumber {
            phone?["number"] = textField.text
        }

    }

}
