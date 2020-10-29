//
//  AddSuppliersViewController.swift
//  warehouse
//
//  Created by Alessandro Perna on 29/10/2020.
//

import UIKit
import RealmSwift

class AddSuppliersViewController: UIViewController {

    @IBOutlet weak var labelTitle:UILabel!
    @IBOutlet weak var labelDescription:UILabel!

    @IBOutlet weak var labelCaptionBusinessName:UILabel!
    @IBOutlet weak var textFieldBusinessName:UITextField!

    @IBOutlet weak var labelCaptionTitle:UILabel!
    @IBOutlet weak var textFieldTitle:UITextField!

    @IBOutlet weak var labelCaptionName:UILabel!
    @IBOutlet weak var textFieldName:UITextField!

    @IBOutlet weak var labelCaptionSurname:UILabel!
    @IBOutlet weak var textFieldSurname:UITextField!

    @IBOutlet weak var labelCaptionVatNumber:UILabel!
    @IBOutlet weak var textFieldVatNumber:UITextField!

    @IBOutlet weak var labelCaptionFiscalCode:UILabel!
    @IBOutlet weak var textFieldFiscalCode:UITextField!

    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var containerView:UIView!

    @IBOutlet weak var labelCaptionPhoneNumber:UILabel!
    @IBOutlet weak var labelCaptionAddressNumber:UILabel!
    @IBOutlet weak var labelCaptionEmailNumber:UILabel!
    @IBOutlet weak var labelCaptionBankNumber:UILabel!

    @IBOutlet weak var stackViewPhone:UIStackView!
    @IBOutlet weak var stackViewAddress:UIStackView!
    @IBOutlet weak var stackViewEmail:UIStackView!
    @IBOutlet weak var stackViewBank:UIStackView!


    var supplierToUpdate:Supplier?
    private let keyboardToolBar = KeyboardToolBar()

    override func viewDidLoad() {
        super.viewDidLoad()

        isModalInPresentation = true

        // Do any additional setup after loading the view.
        registerForKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        keyboardToolBar.nextButtonPressed = {
            self.nextFieldMove()
        }
        keyboardToolBar.doneButtonPressed = {
            self.view.endEditing(true)
        }
        keyboardToolBar.cancelButtonPressed = {
            self.view.endEditing(true)
        }

        if supplierToUpdate != nil{

            labelTitle.initialize(textValue: "Modifica Fornitore", font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold), color: UIColor.darkGray, align: .center)

            labelDescription.initialize(textValue: "Puoi modificare il fornitore, ma non puoi modificare il reparto di appartenenza",
                                        font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light),
                                        color: UIColor.secondaryLabel,
                                        align: .center)


            textFieldBusinessName.delegate = self
            textFieldBusinessName.returnKeyType = .next
            textFieldBusinessName.text = supplierToUpdate?.businessName
            textFieldBusinessName.inputAccessoryView = keyboardToolBar

            textFieldTitle.delegate = self
            textFieldTitle.returnKeyType = .next
            textFieldTitle.text = supplierToUpdate?.title
            textFieldTitle.inputAccessoryView = keyboardToolBar

            textFieldName.delegate = self
            textFieldName.returnKeyType = .next
            textFieldName.text = supplierToUpdate?.name
            textFieldName.inputAccessoryView = keyboardToolBar

            textFieldSurname.delegate = self
            textFieldSurname.returnKeyType = .next
            textFieldSurname.text = supplierToUpdate?.surname
            textFieldSurname.inputAccessoryView = keyboardToolBar

            textFieldVatNumber.delegate = self
            textFieldVatNumber.returnKeyType = .next
            textFieldVatNumber.text = supplierToUpdate?.vatNumber
            textFieldVatNumber.inputAccessoryView = keyboardToolBar

            textFieldFiscalCode.delegate = self
            textFieldFiscalCode.returnKeyType = .next
            textFieldFiscalCode.text = supplierToUpdate?.fiscalCode
            textFieldFiscalCode.inputAccessoryView = keyboardToolBar



        }else{
            labelTitle.initialize(textValue: "Nuovo Fornitore", font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold), color: UIColor.darkGray, align: .center)

            labelDescription.initialize(textValue: "Ricordati di associare i fornitori e i prodotti in base a reparti e categorie",
                                        font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light),
                                        color: UIColor.secondaryLabel,
                                        align: .center)

            textFieldBusinessName.delegate = self
            textFieldBusinessName.returnKeyType = .next
            textFieldBusinessName.inputAccessoryView = keyboardToolBar

            textFieldTitle.delegate = self
            textFieldTitle.returnKeyType = .next
            textFieldTitle.inputAccessoryView = keyboardToolBar

            textFieldName.delegate = self
            textFieldName.returnKeyType = .next
            textFieldName.inputAccessoryView = keyboardToolBar

            textFieldSurname.delegate = self
            textFieldSurname.returnKeyType = .next
            textFieldSurname.inputAccessoryView = keyboardToolBar

            textFieldVatNumber.delegate = self
            textFieldVatNumber.returnKeyType = .next
            textFieldVatNumber.inputAccessoryView = keyboardToolBar

            textFieldFiscalCode.delegate = self
            textFieldFiscalCode.returnKeyType = .next
            textFieldFiscalCode.inputAccessoryView = keyboardToolBar



        }

        labelCaptionBusinessName.initialize(textValue: "Ragione sociale",
                                    font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                    color: UIColor.secondaryLabel,
                                    align: .left)

        labelCaptionTitle.initialize(textValue: "Titolo",
                                    font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                    color: UIColor.secondaryLabel,
                                    align: .left)

        labelCaptionName.initialize(textValue: "Nome",
                                    font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                    color: UIColor.secondaryLabel,
                                    align: .left)

        labelCaptionSurname.initialize(textValue: "Cognome",
                                    font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                    color: UIColor.secondaryLabel,
                                    align: .left)

        labelCaptionVatNumber.initialize(textValue: "Partita I.V.A",
                                    font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                    color: UIColor.secondaryLabel,
                                    align: .left)

        labelCaptionFiscalCode.initialize(textValue: "Codice Fiscale",
                                    font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                    color: UIColor.secondaryLabel,
                                    align: .left)

        labelCaptionPhoneNumber.initialize(textValue: "Telefono",
                                    font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                    color: UIColor.secondaryLabel,
                                    align: .left)

        labelCaptionAddressNumber.initialize(textValue: "Indirizzo",
                                    font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                    color: UIColor.secondaryLabel,
                                    align: .left)

        labelCaptionEmailNumber.initialize(textValue: "Email",
                                    font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                    color: UIColor.secondaryLabel,
                                    align: .left)

        labelCaptionBankNumber.initialize(textValue: "Banca",
                                    font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                    color: UIColor.secondaryLabel,
                                    align: .left)


    }


    //MARK: - functions

    //MARK: - Action
    @IBAction func closeButtonPressed(button:UIButton){
        performSegue(withIdentifier: "unwindToArticle", sender: self)
    }
    @IBAction func saveButtonPressed(button:UIButton){

        guard
            let businessName = textFieldBusinessName.text?.trimmingCharacters(in: .whitespaces),
            businessName.isEmpty == false
        else {
            requestAttention(to: textFieldBusinessName)
            return
        }

        guard
            let title = textFieldTitle.text?.trimmingCharacters(in: .whitespaces),
            title.isEmpty == false
        else {
            requestAttention(to: textFieldTitle)
            return
        }

        guard
            let name = textFieldName.text?.trimmingCharacters(in: .whitespaces),
            name.isEmpty == false
        else {
            requestAttention(to: textFieldName)
            return
        }

        guard
            let surname = textFieldSurname.text?.trimmingCharacters(in: .whitespaces),
            surname.isEmpty == false
        else {
            requestAttention(to: textFieldSurname)
            return
        }

        guard
            let vatNumber = textFieldVatNumber.text?.trimmingCharacters(in: .whitespaces),
            vatNumber.isEmpty == false
        else {
            requestAttention(to: textFieldVatNumber)
            return
        }

        guard
            let fiscalCode = textFieldFiscalCode.text?.trimmingCharacters(in: .whitespaces),
            fiscalCode.isEmpty == false
        else {
            requestAttention(to: textFieldFiscalCode)
            return
        }


        StorageManager.sharedInstance.getDefaultRealm { (realm) in

            realm.beginWrite()

            if let supplierToUpdate = self.supplierToUpdate{

                supplierToUpdate.businessName = businessName
                supplierToUpdate.title = title
                supplierToUpdate.name = name
                supplierToUpdate.surname = surname
                supplierToUpdate.vatNumber = vatNumber
                supplierToUpdate.fiscalCode = fiscalCode

                realm.add(supplierToUpdate, update: .modified)

            }else{

                let supplier:[String:Any] = ["businessName":businessName,
                                             "title":title,
                                             "name":name,
                                             "surname":surname,
                                             "vatNumber":vatNumber,
                                             "fiscalCode":fiscalCode]

                realm.create(Item.self, value: supplier, update: .all)
            }
            do{
                try realm.commitWrite()
            }catch{
                realm.cancelWrite()
                print("Error:\(error.localizedDescription)")
            }


        }

        dismiss(animated: true, completion: nil)
    }

    @IBAction func addNewPhoneButtonPressed(button:UIButton){
        print(#function)
        let phoneView = PhoneView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 120))
        phoneView.delegate = self
        phoneView.tag = 1
        stackViewPhone.spacing = 2
        stackViewPhone.addArrangedSubview(phoneView)
//        var contentSize = self.scrollView.contentSize
//        contentSize.height += 120
//        self.scrollView.contentSize = contentSize
//        self.view.layoutIfNeeded()

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


        let activeField: UITextField? = [textFieldBusinessName,
                                         textFieldTitle,
                                         textFieldName,
                                         textFieldSurname,
                                         textFieldVatNumber,
                                         textFieldFiscalCode].first { $0.isFirstResponder }

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

//MARK: - Field
extension AddSuppliersViewController:UITextFieldDelegate{

    func textFieldDidEndEditing(_ textField: UITextField) {
        checkFields(textField)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextFieldMove()
        return true
    }

    func nextFieldMove(){

        let fields: [UITextField] = [textFieldBusinessName,
                                     textFieldTitle,
                                     textFieldName,
                                     textFieldSurname,
                                     textFieldVatNumber,
                                     textFieldFiscalCode]

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

        if textField == textFieldBusinessName {}
        if textField == textFieldTitle {}
        if textField == textFieldName {}
        if textField == textFieldSurname {}
        if textField == textFieldVatNumber {}
        if textField == textFieldFiscalCode {}

    }

}
//MARK: -  Phone
extension AddSuppliersViewController:PhoneViewDelegate{
    func phoneDataEntryDidDone(view: UIView, phone: [String : Any]) {

    }




}
