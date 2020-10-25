//
//  AddItemsViewController.swift
//  warehouse
//
//  Created by Alessandro Perna on 18/10/2020.
//

import UIKit

class AddItemsFirstStepViewController: UIViewController {

    @IBOutlet weak var labelTitle:UILabel!
    @IBOutlet weak var labelDescription:UILabel!
    @IBOutlet weak var textFieldName:UITextField!
    @IBOutlet weak var textFieldSerialNumber:UITextField!
    @IBOutlet weak var textFieldBarcode:UITextField!

    var item:[String:Any]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        labelTitle.initialize(textValue: "Nuovo Articolo", font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold), color: UIColor.darkGray, align: .center)

        labelDescription.initialize(textValue: "Inserie il nuovo prodotto in tre passaggi. Il numero seriale e il codice a barre sono campi obbligatori",
                                    font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light),
                                    color: UIColor.secondaryLabel,
                                    align: .center)

        textFieldName.placeholder = "Nome"
        textFieldName.autocapitalizationType = .words
        textFieldSerialNumber.placeholder = "Serial number"
        textFieldBarcode.placeholder = "Barcode"
    }

    //MARK - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddItemsSecondStepViewController{
            vc.item = sender as? [String:Any]
        }
    }

    //MARK: - Action
    @IBAction func closeButtonPressed(button:UIButton){
        performSegue(withIdentifier: "unwindToArticle", sender: self)
    }
    @IBAction func nextButtonPressed(button:UIButton){

        guard
            let nameValue = textFieldName.text?.trimmingCharacters(in: .whitespaces),
            nameValue.isEmpty == false
        else {
            requestAttention(to: textFieldName)
            return
        }
        guard
            let serialNumberValue = textFieldSerialNumber.text?.trimmingCharacters(in: .whitespaces),
            serialNumberValue.isEmpty == false
        else {
            requestAttention(to: textFieldSerialNumber)
            return
        }
        guard
            let barcodeNumberValue = textFieldBarcode.text?.trimmingCharacters(in: .whitespaces),
            barcodeNumberValue.isEmpty == false
        else {
            requestAttention(to: textFieldBarcode)
            return
        }

        item = ["name":nameValue,
                "serialNumber":serialNumberValue,
                "barcode":barcodeNumberValue]

        performSegue(withIdentifier: "nextStep", sender: item)
    }

}

extension AddItemsFirstStepViewController: UITextFieldDelegate{

    func textFieldDidEndEditing(_ textField: UITextField) {

        if textField == textFieldName {}
        if textField == textFieldSerialNumber {}
        if textField == textFieldBarcode {
            let barcodeRegEx = "^123456\\d{8}$"
            if !NSPredicate(format: "SELF MATCHES %@", barcodeRegEx).evaluate(with: textField.text ?? ""){
                requestAttention(to: textFieldBarcode)
            }
        }

    }
}
