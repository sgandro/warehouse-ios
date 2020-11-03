//
//  PickerTextView.swift
//  warehouse
//
//  Created by Alessandro Perna on 18/10/2020.
//

import UIKit

class PickerTextView: UITextField {

    private let pickerView = UIPickerView()
    var pickerItemSelected:((_ done:Bool, _ value:String?)->Void)?
    var datasource:[String]?{
        didSet{
            if datasource?.count == 1{
                self.text = datasource?.first
                self.isEnabled = false
                pickerItemSelected?(true, datasource?.first)
            }else if datasource?.count == 0{
                self.text = nil
                self.isEnabled = false
                pickerItemSelected?(false, nil)
            }else{
                self.text = nil
                self.isEnabled = true
                pickerItemSelected?(true, datasource?.first)
            }
            pickerView.reloadComponent(0)
        }
    }
    var selectedValue:String?{
        return self.text
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        UIBarButtonItem.appearance().setTitleTextAttributes(
        [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .semibold),
            NSAttributedString.Key.foregroundColor : UIColor.label,
        ], for: .normal)


        self.inputView = self.pickerView
        self.pickerView.delegate = self
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Chiudi", style: .plain, target: nil, action: #selector(tapCancel))
        let done = UIBarButtonItem(title: "Fatto", style: .plain, target: nil, action: #selector(tapDone))

        toolBar.setItems([cancel, flexible, done], animated: false)
        self.inputAccessoryView = toolBar

    }

    override var isEditing: Bool {
        return false
    }

    @objc func tapCancel() {
        self.resignFirstResponder()
    }

    @objc func tapDone() {
        //salva il risultato
        guard let datasource = self.datasource else {
            self.text = nil
            pickerItemSelected?(false, nil)
            return
        }

        let row = pickerView.selectedRow(inComponent: 0)
        self.text = datasource[row]
        self.resignFirstResponder()
        pickerItemSelected?(true, datasource[row])
    }



}
extension PickerTextView: UIPickerViewDelegate, UIPickerViewDataSource{


    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datasource?.count ?? 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return datasource?[row]
    }

}

