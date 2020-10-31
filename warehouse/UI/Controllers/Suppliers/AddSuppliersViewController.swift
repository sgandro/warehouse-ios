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
    @IBOutlet weak var tableView:UITableView!

    var itemToUpdate:Item?
    var item:[String:Any] = [:]
    var datasource:[[String:Any]]?
    var phoneConfigurtorTable:[[String:Any]]?
    var addressConfigurtorTable:[[String:Any]]?
    var emailsConfigurtorTable:[[String:Any]]?
    var banksConfigurtorTable:[[String:Any]]?
    var phones:[Phone] = [Phone]()
    var addresses:[Address] = [Address]()
    var emails:[Email] = [Email]()
    var banks:[Bank] = [Bank]()
    var supplierToUpdate:Supplier?

    override func viewDidLoad() {
        super.viewDidLoad()

        isModalInPresentation = true

        // Do any additional setup after loading the view.
        tableSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let keyboardToolBar = KeyboardToolBar()
        keyboardToolBar.nextButtonPressed = {
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


        }else{
            labelTitle.initialize(textValue: "Nuovo Fornitore", font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold), color: UIColor.darkGray, align: .center)

            labelDescription.initialize(textValue: "Ricordati di associare i fornitori e i prodotti in base a reparti e categorie",
                                        font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light),
                                        color: UIColor.secondaryLabel,
                                        align: .center)

        }

    }


    //MARK: - Method

    private func tableSettings(){

        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        tableView.bounces = false

        tableView.register(PickerDataEntryTextFiledCell.nibName, forCellReuseIdentifier: PickerDataEntryTextFiledCell.identifier)
        tableView.register(DataEntryTextFiledCell.nibName, forCellReuseIdentifier: DataEntryTextFiledCell.identifier)
        tableView.register(DataEntryPhoneCell.nibName, forCellReuseIdentifier: DataEntryPhoneCell.identifier)
        tableView.register(DataEntryAddressCell.nibName, forCellReuseIdentifier: DataEntryAddressCell.identifier)
        tableView.register(DataEntryEmailCell.nibName, forCellReuseIdentifier: DataEntryEmailCell.identifier)
        tableView.register(DataEntryBankCell.nibName, forCellReuseIdentifier: DataEntryBankCell.identifier)

        datasource = TableConfigurator.getPlistFile(root:"fields", resourceName: "SupplierFields")
        phoneConfigurtorTable = TableConfigurator.getPlistFile(root: "fields", resourceName: "PhoneFields")
        addressConfigurtorTable = TableConfigurator.getPlistFile(root: "fields", resourceName: "AddressFields")
        emailsConfigurtorTable = TableConfigurator.getPlistFile(root: "fields", resourceName: "EmailFields")
        banksConfigurtorTable = TableConfigurator.getPlistFile(root: "fields", resourceName: "BankFields")


    }

    //MARK: - Action
    @IBAction func closeButtonPressed(button:UIButton){
        performSegue(withIdentifier: "unwindToArticle", sender: self)
    }
    @IBAction func saveButtonPressed(button:UIButton){


//        StorageManager.sharedInstance.getDefaultRealm { (realm) in
//
//            realm.beginWrite()
//
//            if let supplierToUpdate = self.supplierToUpdate{
//
//                supplierToUpdate.businessName = businessName
//                supplierToUpdate.title = title
//                supplierToUpdate.name = name
//                supplierToUpdate.surname = surname
//                supplierToUpdate.vatNumber = vatNumber
//                supplierToUpdate.fiscalCode = fiscalCode
//
//                realm.add(supplierToUpdate, update: .modified)
//
//            }else{
//
//                let supplier:[String:Any] = ["businessName":businessName,
//                                             "title":title,
//                                             "name":name,
//                                             "surname":surname,
//                                             "vatNumber":vatNumber,
//                                             "fiscalCode":fiscalCode]
//
//                realm.create(Item.self, value: supplier, update: .all)
//            }
//            do{
//                try realm.commitWrite()
//            }catch{
//                realm.cancelWrite()
//                print("Error:\(error.localizedDescription)")
//            }
//
//
//        }

        dismiss(animated: true, completion: nil)
    }

}

//MARK : - Table
extension AddSuppliersViewController: UITableViewDelegate, UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0: //Supplier
                return datasource?.count ?? 0
            case 1: //Phones
                return phones.count
            case 2: //Emails
                return emails.count
            case 3: //Addresses
                return addresses.count
            case 4: //Banks
                return banks.count
            case 5: //Items
                return 0
            default:
                fatalError()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let datasource = self.datasource else {
            return UITableViewCell()
        }

        switch indexPath.section {
            case 0:

                let field = datasource[indexPath.row]
                if let fieldType = field["type"] as? String{

                    switch fieldType {
                        case "text":

                            let cell = tableView.dequeueReusableCell(withIdentifier: DataEntryTextFiledCell.identifier, for: indexPath) as! DataEntryTextFiledCell
                            cell.caption = field["caption"] as? String
                            cell.delegate = self
                            cell.indexPath = indexPath
                            cell.fieldInfo = field

                            if itemToUpdate != nil{
                                if
                                    let fieldName = field["field"] as? String,
                                    let fieldValue = itemToUpdate?.value(forKey: fieldName) as? String
                                {
                                    cell.textFieldValue.text = fieldValue
                                }
                            }

                            return cell
                        default:
                            fatalError()
                    }
                }

                break
            case 1://Phones

                let cell = tableView.dequeueReusableCell(withIdentifier: DataEntryPhoneCell.identifier, for: indexPath) as! DataEntryPhoneCell
                cell.captionTitle = phoneConfigurtorTable?[0]["caption"] as? String
                cell.captionNumber = phoneConfigurtorTable?[1]["caption"] as? String
                cell.delegate = self
                cell.indexPath = indexPath
                return cell

            case 2://Emails

                let cell = tableView.dequeueReusableCell(withIdentifier: DataEntryEmailCell.identifier, for: indexPath) as! DataEntryEmailCell
                cell.captionType = emailsConfigurtorTable?[0]["caption"] as? String
                cell.captionAddress = emailsConfigurtorTable?[1]["caption"] as? String
                cell.delegate = self
                cell.indexPath = indexPath
                return cell

            case 3://Addresses
                let cell = tableView.dequeueReusableCell(withIdentifier: DataEntryAddressCell.identifier, for: indexPath) as! DataEntryAddressCell
                cell.captionType = addressConfigurtorTable?[0]["caption"] as? String
                cell.captionAddress = addressConfigurtorTable?[1]["caption"] as? String
                cell.captionZipCode = addressConfigurtorTable?[2]["caption"] as? String
                cell.captionCity = addressConfigurtorTable?[3]["caption"] as? String
                cell.captionLocation = addressConfigurtorTable?[4]["caption"] as? String
                cell.delegate = self
                cell.indexPath = indexPath
                return cell

            case 4://Banks
                let cell = tableView.dequeueReusableCell(withIdentifier: DataEntryBankCell.identifier, for: indexPath) as! DataEntryBankCell
                cell.captionName = banksConfigurtorTable?[0]["caption"] as? String
                cell.captionIban = banksConfigurtorTable?[1]["caption"] as? String
                cell.captionSwiftCode = banksConfigurtorTable?[2]["caption"] as? String
                cell.delegate = self
                cell.indexPath = indexPath
                return cell
            case 5://Items
                return UITableViewCell()
            default:
                return UITableViewCell()
        }


        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let addHeaderView = AddHeaderView()

        switch section {
            case 0:
                break
            case 1://Phones
                addHeaderView.labelCaption.text = "Telefono"
                addHeaderView.delegate = self
                addHeaderView.field = ["type":"phone"]
                break
            case 2://Emails
                addHeaderView.labelCaption.text = "Email"
                addHeaderView.delegate = self
                addHeaderView.field = ["type":"email"]
                break
            case 3://Addresses
                addHeaderView.labelCaption.text = "Indirizzo"
                addHeaderView.delegate = self
                addHeaderView.field = ["type":"address"]
                break
            case 4://Banks
                addHeaderView.labelCaption.text = "Banca"
                addHeaderView.delegate = self
                addHeaderView.field = ["type":"bank"]
                break
            case 5://Items
                addHeaderView.labelCaption.text = "Aritcoli"
                addHeaderView.delegate = self
                addHeaderView.field = ["type":"item"]
                break

            default:
                fatalError()
        }
        return addHeaderView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        switch section {
            case 0:
                return 0
            case 1://Phones
                return AddHeaderView.hight
            case 2://Emails
                return AddHeaderView.hight
            case 3://Addresses
                return AddHeaderView.hight
            case 4://Banks
                return AddHeaderView.hight
            case 5://Items
                return AddHeaderView.hight
            default:
                return AddHeaderView.hight
        }

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch indexPath.section {
            case 0:
                return DataEntryTextFiledCell.size.height
            case 1://Phones
                return DataEntryPhoneCell.size.height
            case 2://Emails
                return DataEntryEmailCell.size.height
            case 3://Addresses
                return DataEntryAddressCell.size.height
            case 4://Banks
                return DataEntryBankCell.size.height
            case 5://Items
                return 0
            default:
                return 0
        }

    }


}


//MARK: - DataEntryTextFiledCellDelegate
extension AddSuppliersViewController: DataEntryTextFiledCellDelegate{
    func dataEntryTextFiledDidNext(cell: DataEntryTextFiledCell) {
        self.view.endEditing(true)
    }

    func dataEntryTextFiledDidCheck(cell: DataEntryTextFiledCell) {
        if
            let value = cell.textFieldValue.text,
            !value.isEmpty,
            let fieldInfo = cell.fieldInfo,
            let fieldName = fieldInfo["field"] as? String
        {
            item[fieldName] = value.trimmingCharacters(in: CharacterSet.whitespaces)
        }
    }

    func dataEntryTextFiledDidKeyboardDone(cell: DataEntryTextFiledCell) {
        if
            let value = cell.textFieldValue.text,
            !value.isEmpty,
            let fieldInfo = cell.fieldInfo,
            let fieldName = fieldInfo["field"] as? String
        {
            item[fieldName] = value.trimmingCharacters(in: CharacterSet.whitespaces)
        }

        self.view.endEditing(true)
    }

    func dataEntryTextFiledDidKeyboardCancel(cell: DataEntryTextFiledCell) {
        self.view.endEditing(true)
    }

    func dataEntryTextFiledDidKeyboardNext(cell: DataEntryTextFiledCell) {


        if
            let value = cell.textFieldValue.text,
            !value.isEmpty,
            let fieldInfo = cell.fieldInfo,
            let fieldName = fieldInfo["field"] as? String
        {
            item[fieldName] = value.trimmingCharacters(in: CharacterSet.whitespaces)
        }
    }
}

//MARK: - Header
extension AddSuppliersViewController: AddHeaderViewDelegte{
    func addHeaderViewDidButtonPressed(field: [String : Any]?) {
        print("field:\(String(describing: field))")
        if let fieldName = field?["type"] as? String{

            if fieldName == "phone"{
                let indexPath = IndexPath(row: phones.count, section: 1)
                phones.append(Phone())
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            if fieldName == "email"{
                let indexPath = IndexPath(row: emails.count, section: 2)
                emails.append(Email())
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            if fieldName == "address"{
                let indexPath = IndexPath(row: addresses.count, section: 3)
                addresses.append(Address())
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            if fieldName == "bank"{
                let indexPath = IndexPath(row: banks.count, section: 4)
                banks.append(Bank())
                tableView.insertRows(at: [indexPath], with: .automatic)
            }

        }
    }
}

//MARK: - DataEntryPhoneCellDelegate
extension AddSuppliersViewController: DataEntryPhoneCellDelegate{
    func dataEntryPhoneCellDidNext(cell: DataEntryPhoneCell) {

    }
    
    func dataEntryPhoneCellDidCheck(cell: DataEntryPhoneCell) {

    }
    
    func dataEntryPhoneCellDidKeyboardDone(cell: DataEntryPhoneCell) {

    }
    
    func dataEntryPhoneCellDidKeyboardCancel(cell: DataEntryPhoneCell) {

    }
    
    func dataEntryPhoneCellDidKeyboardNext(cell: DataEntryPhoneCell) {

    }
    

}

//MARK: - DataEntryAddressCellDelegate
extension AddSuppliersViewController: DataEntryAddressCellDelegate{
    func dataEntryAddressCellDidNext(cell: DataEntryAddressCell) {

    }

    func dataEntryAddressCellDidCheck(cell: DataEntryAddressCell) {

    }

    func dataEntryAddressCellDidKeyboardDone(cell: DataEntryAddressCell) {

    }

    func dataEntryAddressCellDidKeyboardCancel(cell: DataEntryAddressCell) {

    }

    func dataEntryAddressCellDidKeyboardNext(cell: DataEntryAddressCell) {
        
    }
}

//MARK: - DataEntryEmailCellDelegate
extension AddSuppliersViewController: DataEntryEmailCellDelegate{
    func dataEntryEmailCellDidNext(cell: DataEntryEmailCell) {

    }

    func dataEntryEmailCellDidCheck(cell: DataEntryEmailCell) {

    }

    func dataEntryEmailCellDidKeyboardDone(cell: DataEntryEmailCell) {

    }

    func dataEntryEmailCellDidKeyboardCancel(cell: DataEntryEmailCell) {

    }

    func dataEntryEmailCellDidKeyboardNext(cell: DataEntryEmailCell) {

    }

}

//MARK: - DataEntryBankCellDelegate
extension AddSuppliersViewController: DataEntryBankCellDelegate{
    func dataEntryBankCellDidNext(cell: DataEntryBankCell) {
    }

    func dataEntryBankCellDidCheck(cell: DataEntryBankCell) {
    }

    func dataEntryBankCellDidKeyboardDone(cell: DataEntryBankCell) {
    }

    func dataEntryBankCellDidKeyboardCancel(cell: DataEntryBankCell) {
    }

    func dataEntryBankCellDidKeyboardNext(cell: DataEntryBankCell) {
    }


}
