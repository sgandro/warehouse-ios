//
//  PickerTextView.swift
//  warehouse
//
//  Created by Alessandro Perna on 18/10/2020.
//

import UIKit

class PickerTextView: UITextField {

    private let pickerView = UIPickerView()
    var datasource:[String]?{
        didSet{
            pickerView.reloadComponent(0)
        }
    }
    var selectedValue:String?{
        return self.text
    }

    override func awakeFromNib() {
        super.awakeFromNib()

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
            return
        }

        let row = pickerView.selectedRow(inComponent: 0)
        self.text = datasource[row]
        self.resignFirstResponder()
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

