//
//  AddItemsViewController.swift
//  warehouse
//
//  Created by Alessandro Perna on 18/10/2020.
//

import UIKit

class AddItemsSecondStepViewController: UIViewController {

    @IBOutlet weak var labelTitle:UILabel!
    @IBOutlet weak var labelDescription:UILabel!
    @IBOutlet weak var textFieldPrice:UITextField!
    @IBOutlet weak var textFieldCurrency:PickerTextView!
    @IBOutlet weak var textFieldVat:UITextField!

    var item:[String:Any]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        labelTitle.initialize(textValue: "Nuovo Articolo", font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold), color: UIColor.darkGray, align: .center)

        labelDescription.initialize(textValue: "Il prezzo, la valuta e la percentuale IVA sono campi obbligatori",
                                    font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light),
                                    color: UIColor.secondaryLabel,
                                    align: .center)

        textFieldPrice.placeholder = "Prezzo"
        textFieldCurrency.placeholder = "Seleziona Valuta"
        textFieldCurrency.datasource = ["EUR"]
        textFieldVat.placeholder = "IVA"

    }

    //MARK - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddItemsThirdStepViewController{
            vc.item = sender as? [String:Any]
        }
    }

    //MARK: - Action
    @IBAction func closeButtonPressed(button:UIButton){
        performSegue(withIdentifier: "unwindToArticle", sender: self)
    }
    @IBAction func nextButtonPressed(button:UIButton){

        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "it_IT")
        formatter.minimumIntegerDigits = 1
        formatter.maximumIntegerDigits = 2

        formatter.numberStyle = .currency

        guard
            let priceValue = textFieldPrice.text,
            priceValue.isEmpty == false,
            let priceDouble = formatter.number(from: priceValue)?.doubleValue
        else {
            requestAttention(to: textFieldPrice)
            return
        }
        guard
            let currencyValue = textFieldCurrency.selectedValue,
            currencyValue.isEmpty == false
        else {
            requestAttention(to: textFieldCurrency)
            return
        }

        formatter.numberStyle = .percent

        guard
            let vatValue = textFieldVat.text,
            vatValue.isEmpty == false,
            let vatDouble = formatter.number(from: vatValue)?.doubleValue
        else {
            requestAttention(to: textFieldVat)
            return
        }

        item?["price"] = priceDouble
        item?["currency"] = currencyValue
        item?["vat"] = vatDouble

        performSegue(withIdentifier: "nextStep", sender: item)

    }
}

extension AddItemsSecondStepViewController: UITextFieldDelegate{

    func textFieldDidEndEditing(_ textField: UITextField) {
        checkFields(textField)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == textFieldPrice {
            textFieldVat.becomeFirstResponder()
        }
        if textField == textFieldVat {
            self.view.endEditing(true)
        }
        //checkFields(textField)
        return true
    }

    func checkFields(_ textField: UITextField){

        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "it_IT")
        formatter.minimumIntegerDigits = 1
        formatter.maximumIntegerDigits = 2

        if textField == textFieldPrice {
            formatter.numberStyle = .currency

            if
                let text = textField.text?.replacingOccurrences(of: ",", with: "."),
                let doubleValue = Double(text)
            {
                textField.text = formatter.string(from: NSNumber(value: doubleValue))
            }else{
                requestAttention(to: textFieldPrice)
            }
        }
        if textField == textFieldCurrency {}
        if textField == textFieldVat {
            formatter.numberStyle = .percent

            if
                let text = textField.text,
                let doubleValue = Double(text)
            {
                textField.text = formatter.string(from: NSNumber(value: doubleValue / 100.0))
            }else{
                requestAttention(to: textFieldVat)
            }
        }

    }
}
