//
//  AddItemsViewController.swift
//  warehouse
//
//  Created by Alessandro Perna on 25/10/2020.
//

import UIKit
import RealmSwift

class AddItemsViewController: UIViewController {

    @IBOutlet weak var labelTitle:UILabel!
    @IBOutlet weak var labelDescription:UILabel!

    @IBOutlet weak var labelCaptionName:UILabel!
    @IBOutlet weak var textFieldName:UITextField!

    @IBOutlet weak var labelCaptionSerialNumber:UILabel!
    @IBOutlet weak var textFieldSerialNumber:UITextField!

    @IBOutlet weak var labelCaptionBarcode:UILabel!
    @IBOutlet weak var textFieldBarcode:UITextField!

    @IBOutlet weak var labelCaptionUnit:UILabel!
    @IBOutlet weak var textFieldUnit:UITextField!

    @IBOutlet weak var labelCaptionQuantity:UILabel!
    @IBOutlet weak var textFieldQuantity:UITextField!

    @IBOutlet weak var labelCaptionPrice:UILabel!
    @IBOutlet weak var textFieldPrice:UITextField!

    @IBOutlet weak var labelCaptionUnitPrice:UILabel!
    @IBOutlet weak var textFieldUnitPrice:UITextField!

    @IBOutlet weak var labelCaptionCurrency:UILabel!
    @IBOutlet weak var textFieldCurrency:PickerTextView!

    @IBOutlet weak var labelCaptionVat:UILabel!
    @IBOutlet weak var textFieldVat:UITextField!

    @IBOutlet weak var labelCaptionMinimumStock:UILabel!
    @IBOutlet weak var textFieldMinimumStock:UITextField!

    @IBOutlet weak var labelCaptionCategoryName:UILabel!
    @IBOutlet weak var textFieldCategoryName:PickerTextView!

    @IBOutlet weak var labelCaptionNote:UILabel!
    @IBOutlet weak var textFieldNote:UITextField!

    @IBOutlet weak var labelCaptionDepartimentName:UILabel!
    @IBOutlet weak var textFieldDepartmentName:PickerTextView!

    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var containerView:UIView!


    var itemToUpdate:Item?
    private let keyboardToolBar = KeyboardToolBar()


    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true

        // Do any additional setup after loading the view.
        registerForKeyboardNotifications()

    }



    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "it_IT")
        formatter.minimumIntegerDigits = 1
        formatter.maximumIntegerDigits = 2

        keyboardToolBar.nextButtonPressed = {
            self.nextFieldMove()
        }
        keyboardToolBar.doneButtonPressed = {
            self.view.endEditing(true)
        }
        keyboardToolBar.cancelButtonPressed = {
            self.view.endEditing(true)
        }

        if itemToUpdate != nil{

            labelTitle.initialize(textValue: "Modifica Articolo", font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold), color: UIColor.darkGray, align: .center)

            labelDescription.initialize(textValue: "Puoi modificare l'articolo, ma non puoi modificare la categoria di appartenenza",
                                        font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light),
                                        color: UIColor.secondaryLabel,
                                        align: .center)

            textFieldName.delegate = self
            textFieldName.returnKeyType = .next
            textFieldName.text = itemToUpdate?.name
            textFieldName.inputAccessoryView = keyboardToolBar

            textFieldBarcode.delegate = self
            textFieldBarcode.returnKeyType = .next
            textFieldBarcode.text = itemToUpdate?.barcode
            textFieldBarcode.inputAccessoryView = keyboardToolBar

            textFieldSerialNumber.delegate = self
            textFieldSerialNumber.returnKeyType = .next
            textFieldSerialNumber.text = itemToUpdate?.serialNumber
            textFieldSerialNumber.inputAccessoryView = keyboardToolBar

            textFieldUnit.delegate = self
            textFieldUnit.returnKeyType = .next
            textFieldUnit.text = itemToUpdate?.unit
            textFieldUnit.inputAccessoryView = keyboardToolBar

            formatter.numberStyle = .none

            textFieldQuantity.delegate = self
            textFieldQuantity.returnKeyType = .next
            textFieldQuantity.text = formatter.string(from: NSNumber(value: itemToUpdate?.quantity ?? 0))
            textFieldQuantity.inputAccessoryView = keyboardToolBar

            formatter.numberStyle = .currency

            textFieldPrice.delegate = self
            textFieldPrice.returnKeyType = .next
            textFieldPrice.text = formatter.string(from: NSNumber(value: itemToUpdate?.price ?? 0.0))
            textFieldPrice.inputAccessoryView = keyboardToolBar

            textFieldUnitPrice.delegate = self
            textFieldUnitPrice.returnKeyType = .next
            textFieldUnitPrice.text = formatter.string(from: NSNumber(value: itemToUpdate?.unitPrice ?? 0.0))
            textFieldUnitPrice.inputAccessoryView = keyboardToolBar

            textFieldCurrency.delegate = self
            textFieldCurrency.returnKeyType = .next
            textFieldCurrency.datasource = [self.itemToUpdate?.currency ?? "EUR"]
            textFieldCurrency.inputAccessoryView = keyboardToolBar

            formatter.numberStyle = .percent

            textFieldVat.delegate = self
            textFieldVat.returnKeyType = .next
            textFieldVat.text = formatter.string(from: NSNumber(value: (itemToUpdate?.vat ?? 0.0)))
            textFieldVat.inputAccessoryView = keyboardToolBar

            formatter.numberStyle = .none

            textFieldMinimumStock.delegate = self
            textFieldMinimumStock.returnKeyType = .next
            textFieldMinimumStock.text = formatter.string(from: NSNumber(value: itemToUpdate?.minimumStock ?? 0))
            textFieldMinimumStock.inputAccessoryView = keyboardToolBar

            textFieldCategoryName.delegate = self
            textFieldCategoryName.returnKeyType = .next
            if let categoryName = self.itemToUpdate?.categories.first?.name{
                self.textFieldCategoryName.datasource = [categoryName]
            }

            textFieldNote.delegate = self
            textFieldNote.returnKeyType = .next
            textFieldNote.text = itemToUpdate?.note
            textFieldNote.inputAccessoryView = keyboardToolBar

            textFieldDepartmentName.delegate = self
            textFieldDepartmentName.returnKeyType = .next
            textFieldDepartmentName.placeholder = "Seleziona reparto"

            if let departmentName = self.itemToUpdate?.categories.first?.department.first?.name{
                self.textFieldDepartmentName.datasource = [departmentName]
            }



        }else{
            labelTitle.initialize(textValue: "Nuovo Articolo", font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold), color: UIColor.darkGray, align: .center)

            labelDescription.initialize(textValue: "Prima di inserire i dati è necessario creare un reparto e una categoria a cui associare il prodotto",
                                        font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light),
                                        color: UIColor.secondaryLabel,
                                        align: .center)

            textFieldName.delegate = self
            textFieldName.returnKeyType = .next
            textFieldName.inputAccessoryView = keyboardToolBar

            textFieldBarcode.delegate = self
            textFieldBarcode.returnKeyType = .next
            textFieldBarcode.keyboardType = .numberPad
            textFieldBarcode.inputAccessoryView = keyboardToolBar

            textFieldSerialNumber.delegate = self
            textFieldSerialNumber.returnKeyType = .next
            textFieldSerialNumber.keyboardType = .asciiCapable
            textFieldSerialNumber.inputAccessoryView = keyboardToolBar

            textFieldUnit.delegate = self
            textFieldUnit.returnKeyType = .next
            textFieldUnit.keyboardType = .asciiCapable
            textFieldUnit.inputAccessoryView = keyboardToolBar

            textFieldQuantity.delegate = self
            textFieldQuantity.returnKeyType = .next
            textFieldQuantity.keyboardType = .numberPad
            textFieldQuantity.inputAccessoryView = keyboardToolBar

            textFieldPrice.delegate = self
            textFieldPrice.returnKeyType = .next
            textFieldPrice.keyboardType = .decimalPad
            textFieldPrice.inputAccessoryView = keyboardToolBar

            textFieldUnitPrice.delegate = self
            textFieldUnitPrice.returnKeyType = .next
            textFieldUnitPrice.keyboardType = .decimalPad
            textFieldUnitPrice.inputAccessoryView = keyboardToolBar

            textFieldCurrency.delegate = self
            textFieldCurrency.returnKeyType = .next
            textFieldCurrency.placeholder = "Seleziona valuta"

            textFieldCurrency.datasource = ["EUR"]
            textFieldCurrency.pickerItemSelected = {(done) in
                self.nextFieldMove()
            }

            textFieldVat.delegate = self
            textFieldVat.returnKeyType = .next
            textFieldVat.keyboardType = .numberPad
            textFieldVat.inputAccessoryView = keyboardToolBar

            textFieldMinimumStock.delegate = self
            textFieldMinimumStock.returnKeyType = .next
            textFieldMinimumStock.keyboardType = .numberPad
            textFieldMinimumStock.inputAccessoryView = keyboardToolBar

            textFieldCategoryName.delegate = self
            textFieldCategoryName.returnKeyType = .next
            textFieldCategoryName.placeholder = "Seleziona categoria"

            textFieldCategoryName.pickerItemSelected = {(done) in
                self.nextFieldMove()
                if done{
                    self.loadDepartiments()
                }
            }
            self.loadCategories()

            textFieldNote.delegate = self
            textFieldNote.returnKeyType = .next
            textFieldNote.inputAccessoryView = keyboardToolBar

            textFieldDepartmentName.delegate = self
            textFieldDepartmentName.returnKeyType = .next
            textFieldDepartmentName.placeholder = "Seleziona reparto"
            textFieldDepartmentName.inputAccessoryView = keyboardToolBar

            textFieldDepartmentName.pickerItemSelected = {(done) in
                self.nextFieldMove()
                if done {
                    self.loadCategories()
                }
            }
            self.loadDepartiments()


        }

        labelCaptionName.initialize(textValue: "Nome",
                                    font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                    color: UIColor.secondaryLabel,
                                    align: .left)

        labelCaptionSerialNumber.initialize(textValue: "Numero seriale",
                                            font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                            color: UIColor.secondaryLabel,
                                            align: .left)

        labelCaptionCurrency.initialize(textValue: "Valuta",
                                        font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                        color: UIColor.secondaryLabel,
                                        align: .left)

        labelCaptionBarcode.initialize(textValue: "Barcode",
                                       font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                       color: UIColor.secondaryLabel,
                                       align: .left)

        labelCaptionUnit.initialize(textValue: "Unità di misura",
                                       font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                       color: UIColor.secondaryLabel,
                                       align: .left)

        labelCaptionQuantity.initialize(textValue: "Quantità",
                                       font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                       color: UIColor.secondaryLabel,
                                       align: .left)

        labelCaptionUnitPrice.initialize(textValue: "Prezzo unitario",
                                       font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                       color: UIColor.secondaryLabel,
                                       align: .left)

        labelCaptionPrice.initialize(textValue: "Prezzo",
                                       font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                       color: UIColor.secondaryLabel,
                                       align: .left)

        labelCaptionCurrency.initialize(textValue: "Valuta",
                                       font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                       color: UIColor.secondaryLabel,
                                       align: .left)

        labelCaptionVat.initialize(textValue: "I.V.A.",
                                       font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                       color: UIColor.secondaryLabel,
                                       align: .left)

        labelCaptionCategoryName.initialize(textValue: "Categoria",
                                            font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                            color: UIColor.secondaryLabel,
                                            align: .left)

        labelCaptionMinimumStock.initialize(textValue: "Scorta minima",
                                            font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                            color: UIColor.secondaryLabel,
                                            align: .left)

        labelCaptionNote.initialize(textValue: "Note",
                                       font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                       color: UIColor.secondaryLabel,
                                       align: .left)

        labelCaptionDepartimentName.initialize(textValue: "Dipartimento",
                                               font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                               color: UIColor.secondaryLabel,
                                               align: .left)




    }


    //MARK: - functions
    func loadCategories(){
        StorageManager.sharedInstance.getDefaultRealm { (realm) in
            if let departimentName = self.textFieldDepartmentName.selectedValue, departimentName.isEmpty == false{
                self.textFieldCategoryName.datasource = realm.objects(Category.self).filter("ANY department.name == %@", departimentName).map({$0.name})
            }else{
                self.textFieldCategoryName.datasource = realm.objects(Category.self).map({$0.name})
            }
            let count = self.textFieldCategoryName.datasource?.count ?? 0
            if count == 0{
                self.showAlert(title: "Informazione", andBody: "Creare prima una categoria")
            }
        }
    }

    func loadDepartiments(){
        StorageManager.sharedInstance.getDefaultRealm { (realm) in
            if let categoryName = self.textFieldCategoryName.selectedValue, categoryName.isEmpty == false{
                self.textFieldDepartmentName.datasource = realm.objects(Department.self).filter("ANY categories.name == %@", categoryName).map({$0.name})
            }else{
                self.textFieldDepartmentName.datasource = realm.objects(Department.self).map({$0.name})
            }

            let count = self.textFieldDepartmentName.datasource?.count ?? 0
            if count == 0{
                self.showAlert(title: "Informazione", andBody: "Creare prima un reparto")
            }

        }

    }

    //MARK: - Action
    @IBAction func closeButtonPressed(button:UIButton){
        performSegue(withIdentifier: "unwindToArticle", sender: self)
    }
    @IBAction func saveButtonPressed(button:UIButton){

        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "it_IT")
        formatter.minimumIntegerDigits = 1
        formatter.maximumIntegerDigits = 2

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

        guard
            let categoryNameValue = textFieldCategoryName.selectedValue,
            categoryNameValue.isEmpty == false
        else {
            requestAttention(to: textFieldCategoryName)
            return
        }

        guard
            let unitValue = textFieldUnit.text?.trimmingCharacters(in: .whitespaces),
            unitValue.isEmpty == false
        else {
            requestAttention(to: textFieldUnit)
            return
        }

        guard
            let noteValue = textFieldNote.text?.trimmingCharacters(in: .whitespaces),
            noteValue.isEmpty == false
        else {
            requestAttention(to: textFieldNote)
            return
        }

        formatter.numberStyle = .currency

        guard
            let unitPriceValue = textFieldUnitPrice.text,
            unitPriceValue.isEmpty == false,
            let unitPriceDouble = formatter.number(from: unitPriceValue)?.doubleValue
        else {
            requestAttention(to: textFieldUnitPrice)
            return
        }

        guard
            let minimumStockValue = textFieldMinimumStock.text,
            minimumStockValue.isEmpty == false,
            let minimumStockInteger = Int(minimumStockValue)
        else {
            requestAttention(to: textFieldMinimumStock)
            return
        }

        guard
            let quantityValue = textFieldQuantity.text,
            quantityValue.isEmpty == false,
            let quantityInteger = Int(quantityValue)
        else {
            requestAttention(to: textFieldQuantity)
            return
        }



        StorageManager.sharedInstance.getDefaultRealm { (realm) in

            if let category = realm.objects(Category.self).first(where: {$0.name == categoryNameValue}){
                realm.beginWrite()

                if let itemToUpdate = self.itemToUpdate{

                    itemToUpdate.name = nameValue
                    itemToUpdate.serialNumber = serialNumberValue
                    itemToUpdate.barcode = barcodeNumberValue
                    itemToUpdate.price = priceDouble
                    itemToUpdate.unitPrice = unitPriceDouble
                    itemToUpdate.currency = currencyValue
                    itemToUpdate.unit = unitValue
                    itemToUpdate.quantity = quantityInteger
                    itemToUpdate.vat = vatDouble
                    itemToUpdate.note = noteValue
                    itemToUpdate.minimumStock = minimumStockInteger
                    realm.add(category, update: .modified)

                }else{

                    let item:[String:Any] = ["name":nameValue,
                                             "serialNumber":serialNumberValue,
                                             "barcode":barcodeNumberValue,
                                             "price":priceDouble,
                                             "unitPrice":unitPriceDouble,
                                             "currency":currencyValue,
                                             "unit":unitValue,
                                             "quantity":quantityInteger,
                                             "vat":vatDouble,
                                             "note":noteValue,
                                             "minimumStock":minimumStockInteger]

                    let newItem = realm.create(Item.self, value: item, update: .all)
                    category.items.append(newItem)
                }
                do{
                    try realm.commitWrite()
                }catch{
                    realm.cancelWrite()
                    print("Error:\(error.localizedDescription)")
                }

            }

        }

        dismiss(animated: true, completion: nil)
    }

    //MARK: - keyboard

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onKeyboardAppear(_:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onKeyboardDisappear(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onKeyboardDisappear(_:)),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
    }

    // Don't forget to unregister when done
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardDidShowNotification,
                                                  object: nil)

        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillChangeFrameNotification,
                                                  object: nil)

        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardDidHideNotification,
                                                  object: nil)
    }

    @objc func onKeyboardAppear(_ notification: NSNotification) {
        let info = notification.userInfo!
        let rect = info[UIResponder.keyboardFrameBeginUserInfoKey] as! CGRect
        let kbSize = rect.size

        let insets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height + keyboardToolBar.frame.height, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets

        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your application might not need or want this behavior.
        var aRect = self.containerView.frame;
        aRect.size.height -= kbSize.height + keyboardToolBar.frame.height;

        let activeField: UITextField? = [textFieldName,
                                         textFieldSerialNumber,
                                         textFieldBarcode,
                                         textFieldDepartmentName,
                                         textFieldCategoryName,
                                         textFieldUnit,
                                         textFieldQuantity,
                                         textFieldCurrency,
                                         textFieldUnitPrice,
                                         textFieldPrice,
                                         textFieldVat,
                                         textFieldMinimumStock,
                                         textFieldNote].first { $0.isFirstResponder }

        if let activeField = activeField {
            if !aRect.contains(activeField.frame.origin) {
                let scrollPoint = CGPoint(x: 0, y: activeField.frame.origin.y-kbSize.height)
                scrollView.setContentOffset(scrollPoint, animated: true)
            }
        }
    }

    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }



}


extension AddItemsViewController:UITextFieldDelegate{

    func textFieldDidEndEditing(_ textField: UITextField) {
        checkFields(textField)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextFieldMove()
        return true
    }

    func nextFieldMove(){

        let fields: [UITextField] = [textFieldName,
                                     textFieldSerialNumber,
                                     textFieldBarcode,
                                     //textFieldDepartmentName,
                                     //textFieldCategoryName,
                                     textFieldUnit,
                                     textFieldQuantity,
                                     //textFieldCurrency,
                                     textFieldUnitPrice,
                                     textFieldPrice,
                                     textFieldVat,
                                     textFieldMinimumStock,
                                     textFieldNote]

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

        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "it_IT")
        formatter.minimumIntegerDigits = 1
        formatter.maximumIntegerDigits = 2

        if textField == textFieldName {}
        if textField == textFieldSerialNumber {}
        if textField == textFieldBarcode {}
        
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

        if textField == textFieldUnitPrice {
            formatter.numberStyle = .currency

            if
                let text = textField.text?.replacingOccurrences(of: ",", with: "."),
                let doubleValue = Double(text)
            {
                textField.text = formatter.string(from: NSNumber(value: doubleValue))
            }else{
                requestAttention(to: textFieldUnitPrice)
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

        if textField == textFieldDepartmentName {}
        if textField == textFieldCategoryName {}
        if textField == textFieldUnit {}
        if textField == textFieldQuantity {
            formatter.numberStyle = .none

            if
                let text = textField.text,
                let integerValue = Int(text)
            {
                textField.text = formatter.string(from: NSNumber(value: integerValue))
            }else{
                requestAttention(to: textFieldQuantity)
            }
        }
        if textField == textFieldMinimumStock {
            formatter.numberStyle = .none

            if
                let text = textField.text,
                let integerValue = Int(text)
            {
                textField.text = formatter.string(from: NSNumber(value: integerValue))
            }else{
                requestAttention(to: textFieldQuantity)
            }

        }
        if textField == textFieldNote {}

    }

}
