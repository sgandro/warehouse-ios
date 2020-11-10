//
//  AddSuppliersViewController.swift
//  warehouse
//
//  Created by Alessandro Perna on 29/10/2020.
//

import UIKit
import RealmSwift

class AddSuppliersViewController: BaseTableViewController {

    @IBOutlet weak var labelTitle:UILabel!
    @IBOutlet weak var labelDescription:UILabel!
    @IBOutlet weak var tableView:UITableView!

    var datasource:[[String:Any]]?
    var phoneConfigurtorTable:[[String:Any]]?
    var addressConfigurtorTable:[[String:Any]]?
    var emailsConfigurtorTable:[[String:Any]]?
    var banksConfigurtorTable:[[String:Any]]?
    var phones:List<Phone> = List<Phone>()
    var addresses:List<Address> = List<Address>()
    var emails:List<Email> = List<Email>()
    var banks:List<Bank> = List<Bank>()
    var supplierToUpdate:Supplier?
    var supplier:[String:Any] = [:]

    var category:Category?
    private var department:Department?
    private var categories:Results<Category>?
    private var departments:Results<Department>?

    override func viewDidLoad() {
        super.viewDidLoad()

        isKeyboardNotificationEnabled = true

        // Do any additional setup after loading the view.
        tableSettings()
        loadCategories()
        loadDepartiments()
        loadBanks()
        loadEmails()
        loadPhones()
        loadAddress()

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

            labelTitle.initialize(textValue: "Modifica Fornitore",
                                  font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold),
                                  color: UIColor.darkGray,
                                  align: .center)

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

    override func keyboardWillShowNotification(notification: Notification, rect: CGRect) {
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: rect.height, right: 0)
    }

    override func keyboardWillChangeFrameNotification(notification: Notification, rect: CGRect) {
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: rect.height, right: 0)
    }

    override func keyboardWillHideNotification(notification: Notification, rect: CGRect) {
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: rect.height, right: 0)
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

    private func loadCategories(){
        StorageManager.sharedInstance.getDefaultRealm { (realm) in

            if let categoryId = self.category?.id{
                self.categories = realm.objects(Category.self).filter("id = %@",categoryId)
            }else{
                self.categories = realm.objects(Category.self)
            }

            let count = self.categories?.count ?? 0
            if count == 0{
                self.showAlert(title: "Informazione", andBody: "Creare prima una categoria")
            }
        }

    }

    private func loadDepartiments(){
        StorageManager.sharedInstance.getDefaultRealm { (realm) in

            if let categoryId = self.category?.id{
                self.departments = realm.objects(Department.self).filter("ANY categories.id = %@",categoryId)
            }else{
                self.departments = realm.objects(Department.self)
            }
            let count = self.departments?.count ?? 0
            if count == 0{
                self.showAlert(title: "Informazione", andBody: "Creare prima un reparto")
            }
        }

    }

    private func loadBanks(){
        self.banks = self.supplierToUpdate?.banks ?? List<Bank>()
    }
    
    private func loadEmails(){
        self.emails = self.supplierToUpdate?.emails ?? List<Email>()
    }

    private func loadPhones(){
        self.phones = self.supplierToUpdate?.phones ?? List<Phone>()
    }

    private func loadAddress(){
        self.addresses = self.supplierToUpdate?.addresses ?? List<Address>()
    }


    //MARK: - Action
    @IBAction func closeButtonPressed(button:UIButton){
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveButtonPressed(button:UIButton){


        StorageManager.sharedInstance.getDefaultRealm { (realm) in

            if
                let categoryName = self.supplier["category"] as? String,
                let category = realm.objects(Category.self).first(where: {$0.name == categoryName})
            {

                realm.beginWrite()

                if let supplierToUpdate = self.supplierToUpdate{

                    if let businessName = self.supplier["businessName"] as? String {
                        supplierToUpdate.businessName = businessName
                    }
                    if let title = self.supplier["title"] as? String {
                        supplierToUpdate.title = title
                    }
                    if let name = self.supplier["name"] as? String {
                        supplierToUpdate.name = name
                    }
                    if let surname = self.supplier["surname"] as? String {
                        supplierToUpdate.surname = surname
                    }
                    if let vatNumber = self.supplier["vatNumber"] as? String {
                        supplierToUpdate.vatNumber = vatNumber
                    }
                    if let fiscalCode = self.supplier["fiscalCode"] as? String {
                        supplierToUpdate.fiscalCode = fiscalCode
                    }

                    realm.add(supplierToUpdate, update: .modified)

                }else{

                    let newSupplier = realm.create(Supplier.self, value: self.supplier, update: .all)
                    newSupplier.phones.append(objectsIn: self.phones)
                    newSupplier.addresses.append(objectsIn: self.addresses)
                    newSupplier.emails.append(objectsIn: self.emails)
                    newSupplier.banks.append(objectsIn: self.banks)
                    category.suppliers.append(newSupplier)

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

                            if supplierToUpdate != nil{

                                if
                                    let fieldName = field["field"] as? String,
                                    let fieldFormat = field["format"] as? String
                                {
                                    switch fieldFormat {
                                        case "string":
                                            cell.textFieldValue.text = supplierToUpdate?.value(forKey: fieldName) as? String
                                            cell.applayFieldFormat()
                                        case "currency","percent":
                                            let doubleValue = (supplierToUpdate?.value(forKey: fieldName) as? Double) ?? 0.0
                                            cell.textFieldValue.text = "\(doubleValue)"
                                            cell.applayFieldFormat()
                                        case "integer":
                                            let intValue = (supplierToUpdate?.value(forKey: fieldName) as? Int) ?? 0
                                            cell.textFieldValue.text = "\(intValue)"
                                            cell.applayFieldFormat()
                                        default:
                                            fatalError()
                                    }
                                }
                            }else{
                                if
                                    let fieldName = field["field"] as? String,
                                    let fieldFormat = field["format"] as? String
                                {
                                    switch fieldFormat {
                                        case "string":
                                            cell.textFieldValue.text = supplier[fieldName] as? String
                                        case "currency","percent":
                                            let doubleValue = (supplier[fieldName] as? Double) ?? 0.0
                                            cell.textFieldValue.text = "\(doubleValue)"
                                            cell.applayFieldFormat()
                                        case "integer":
                                            let intValue = (supplier[fieldName] as? Int) ?? 0
                                            cell.textFieldValue.text = "\(intValue)"
                                            cell.applayFieldFormat()
                                        default:
                                            fatalError()
                                    }
                                }
                            }

                            return cell
                        case "picker":

                            let cell = tableView.dequeueReusableCell(withIdentifier: PickerDataEntryTextFiledCell.identifier, for: indexPath) as! PickerDataEntryTextFiledCell

                            cell.caption = field["caption"] as? String
                            cell.indexPath = indexPath
                            cell.delegate = self
                            cell.fieldInfo = field
                            cell.delegate = self

                            if supplierToUpdate != nil{

                                if let source = field["source"] as? String{

                                    switch source {
                                        case "department":
                                            if let departmentName = self.supplierToUpdate?.categories.first?.department.first?.name{
                                                cell.pickerTextView.datasource = [departmentName]
                                            }
                                        case "category":
                                            if let categoryName = supplierToUpdate?.categories.first?.name{
                                                cell.pickerTextView.datasource = [categoryName]
                                            }
                                        default:
                                            fatalError()
                                    }
                                }

                            }else{

                                if let source = field["source"] as? String{

                                    switch source {
                                        case "department":
                                            cell.pickerTextView.datasource = self.departments?.map({$0.name})
                                        case "category":
                                            cell.pickerTextView.datasource = self.categories?.map({$0.name})
                                        default:
                                        fatalError()
                                    }
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
                cell.textTitleField.text = self.phones[indexPath.row].type
                cell.captionNumber = phoneConfigurtorTable?[1]["caption"] as? String
                cell.textNumberField.text = self.phones[indexPath.row].number
                cell.delegate = self
                cell.indexPath = indexPath
                return cell

            case 2://Emails

                let cell = tableView.dequeueReusableCell(withIdentifier: DataEntryEmailCell.identifier, for: indexPath) as! DataEntryEmailCell
                cell.captionType = emailsConfigurtorTable?[0]["caption"] as? String
                cell.textTypeField.text = self.emails[indexPath.row].type
                cell.captionAddress = emailsConfigurtorTable?[1]["caption"] as? String
                cell.textAddressField.text = self.emails[indexPath.row].address
                cell.delegate = self
                cell.indexPath = indexPath
                return cell

            case 3://Addresses

                let cell = tableView.dequeueReusableCell(withIdentifier: DataEntryAddressCell.identifier, for: indexPath) as! DataEntryAddressCell
                cell.captionType = addressConfigurtorTable?[0]["caption"] as? String
                cell.textTypeField.text = self.addresses[indexPath.row].type
                cell.captionAddress = addressConfigurtorTable?[1]["caption"] as? String
                cell.textAddressField.text = self.addresses[indexPath.row].address
                cell.captionZipCode = addressConfigurtorTable?[2]["caption"] as? String
                cell.textZipCodeField.text = self.addresses[indexPath.row].zipCode
                cell.captionCity = addressConfigurtorTable?[3]["caption"] as? String
                cell.textCityField.text = self.addresses[indexPath.row].city
                cell.captionLocation = addressConfigurtorTable?[4]["caption"] as? String
                cell.textLocationField.text = self.addresses[indexPath.row].location
                cell.delegate = self
                cell.indexPath = indexPath
                return cell

            case 4://Banks

                let cell = tableView.dequeueReusableCell(withIdentifier: DataEntryBankCell.identifier, for: indexPath) as! DataEntryBankCell
                cell.captionName = banksConfigurtorTable?[0]["caption"] as? String
                cell.textNameField.text = self.banks[indexPath.row].name
                cell.captionIban = banksConfigurtorTable?[1]["caption"] as? String
                cell.textIbanField.text = self.banks[indexPath.row].iban
                cell.captionSwiftCode = banksConfigurtorTable?[2]["caption"] as? String
                cell.textSwiftField.text = self.banks[indexPath.row].swift
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

//MARK: - DataEntryTextFiledCellDelegate
extension AddSuppliersViewController: DataEntryTextFiledCellDelegate{
    func dataEntryTextFiledDidNext(cell: DataEntryTextFiledCell) {
        self.view.endEditing(true)
    }

    func dataEntryTextFiledDidCheck(cell: DataEntryTextFiledCell) {
        getEntryTextField(cell: cell)
    }

    func dataEntryTextFiledDidKeyboardDone(cell: DataEntryTextFiledCell) {
        getEntryTextField(cell: cell)
        self.view.endEditing(true)
    }

    func dataEntryTextFiledDidKeyboardCancel(cell: DataEntryTextFiledCell) {
        self.view.endEditing(true)
    }

    func dataEntryTextFiledDidKeyboardNext(cell: DataEntryTextFiledCell) {
        getEntryTextField(cell: cell)
        guard let count = datasource?.count else {
            return
        }
        var indexPath = cell.indexPath
        if  indexPath != nil{
            if indexPath!.row < (count - 1){
                indexPath!.row = indexPath!.row + 1
                tableView.selectRow(at: indexPath!, animated: true, scrollPosition: .top)
            }
        }

    }

    private func getEntryTextField(cell: DataEntryTextFiledCell){
        if
            let value = cell.textFieldValue.text,
            !value.isEmpty,
            let fieldInfo = cell.fieldInfo,
            let fieldName = fieldInfo["field"] as? String
        {
            supplier[fieldName] = value.trimmingCharacters(in: CharacterSet.whitespaces)
        }
    }
}

//MARK: - DataEntryPhoneCellDelegate
extension AddSuppliersViewController: DataEntryPhoneCellDelegate{
    func dataEntryPhoneCellDidNext(cell: DataEntryPhoneCell) {
        self.view.endEditing(true)
    }
    
    func dataEntryPhoneCellDidCheck(cell: DataEntryPhoneCell) {
        getPhoneCell(cell: cell)
    }
    
    func dataEntryPhoneCellDidKeyboardDone(cell: DataEntryPhoneCell) {
        getPhoneCell(cell: cell)
        self.view.endEditing(true)
    }
    
    func dataEntryPhoneCellDidKeyboardCancel(cell: DataEntryPhoneCell) {
        self.view.endEditing(true)
    }
    
    func dataEntryPhoneCellDidKeyboardNext(cell: DataEntryPhoneCell) {
        getPhoneCell(cell: cell)
        guard let count = datasource?.count else {
            return
        }
        var indexPath = cell.indexPath
        if  indexPath != nil{
            if indexPath!.row < (count - 1){
                indexPath!.row = indexPath!.row + 1
                tableView.selectRow(at: indexPath!, animated: true, scrollPosition: .top)
            }
        }

    }

    private func getPhoneCell(cell: DataEntryPhoneCell){
        guard
            let indexPath = cell.indexPath
        else { return }

        let phone = phones[indexPath.row]
        if
            let value = cell.textTitleField.text,
            !value.isEmpty
        {
            phone.type = value.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        if
            let value = cell.textNumberField.text,
            !value.isEmpty
        {
            phone.number = value.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        phones.replace(index: indexPath.row, object: phone)
    }
    

}

//MARK: - DataEntryAddressCellDelegate
extension AddSuppliersViewController: DataEntryAddressCellDelegate{
    func dataEntryAddressCellDidNext(cell: DataEntryAddressCell) {
        self.view.endEditing(true)
    }

    func dataEntryAddressCellDidCheck(cell: DataEntryAddressCell) {
        getAddressCell(cell: cell)
    }

    func dataEntryAddressCellDidKeyboardDone(cell: DataEntryAddressCell) {
        getAddressCell(cell: cell)
        self.view.endEditing(true)
    }

    func dataEntryAddressCellDidKeyboardCancel(cell: DataEntryAddressCell) {
        self.view.endEditing(true)
    }

    func dataEntryAddressCellDidKeyboardNext(cell: DataEntryAddressCell) {
        getAddressCell(cell: cell)
        guard let count = datasource?.count else {
            return
        }
        var indexPath = cell.indexPath
        if  indexPath != nil{
            if indexPath!.row < (count - 1){
                indexPath!.row = indexPath!.row + 1
                tableView.selectRow(at: indexPath!, animated: true, scrollPosition: .top)
            }
        }

    }

    private func getAddressCell(cell: DataEntryAddressCell){
        guard
            let indexPath = cell.indexPath
        else { return }

        let address = addresses[indexPath.row]
        if
            let value = cell.textTypeField.text,
            !value.isEmpty
        {
            address.type = value.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        if
            let value = cell.textLocationField.text,
            !value.isEmpty
        {
            address.location = value.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        if
            let value = cell.textCityField.text,
            !value.isEmpty
        {
            address.city = value.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        if
            let value = cell.textZipCodeField.text,
            !value.isEmpty
        {
            address.zipCode = value.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        if
            let value = cell.textAddressField.text,
            !value.isEmpty
        {
            address.address = value.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        addresses.replace(index: indexPath.row, object: address)
    }

}

//MARK: - DataEntryEmailCellDelegate
extension AddSuppliersViewController: DataEntryEmailCellDelegate{
    func dataEntryEmailCellDidNext(cell: DataEntryEmailCell) {
        self.view.endEditing(true)
    }

    func dataEntryEmailCellDidCheck(cell: DataEntryEmailCell) {
        getEmailCell(cell: cell)
    }

    func dataEntryEmailCellDidKeyboardDone(cell: DataEntryEmailCell) {
        getEmailCell(cell: cell)
        self.view.endEditing(true)

    }

    func dataEntryEmailCellDidKeyboardCancel(cell: DataEntryEmailCell) {
        self.view.endEditing(true)
    }

    func dataEntryEmailCellDidKeyboardNext(cell: DataEntryEmailCell) {
        getEmailCell(cell: cell)
        guard let count = datasource?.count else {
            return
        }
        var indexPath = cell.indexPath
        if  indexPath != nil{
            if indexPath!.row < (count - 1){
                indexPath!.row = indexPath!.row + 1
                tableView.selectRow(at: indexPath!, animated: true, scrollPosition: .top)
            }
        }

    }

    private func getEmailCell(cell: DataEntryEmailCell){
        guard
            let indexPath = cell.indexPath
        else { return }

        let email = emails[indexPath.row]
        if
            let value = cell.textTypeField.text,
            !value.isEmpty
        {
            email.type = value.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        if
            let value = cell.textAddressField.text,
            !value.isEmpty
        {
            email.address = value.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        emails.replace(index: indexPath.row, object: email)
    }
}

//MARK: - DataEntryBankCellDelegate
extension AddSuppliersViewController: DataEntryBankCellDelegate{
    func dataEntryBankCellDidNext(cell: DataEntryBankCell) {
        self.view.endEditing(true)
    }

    func dataEntryBankCellDidCheck(cell: DataEntryBankCell) {
        getBankCell(cell: cell)
    }

    func dataEntryBankCellDidKeyboardDone(cell: DataEntryBankCell) {
        getBankCell(cell: cell)
        self.view.endEditing(true)
    }

    func dataEntryBankCellDidKeyboardCancel(cell: DataEntryBankCell) {
        self.view.endEditing(true)
    }

    func dataEntryBankCellDidKeyboardNext(cell: DataEntryBankCell) {
        getBankCell(cell: cell)
        guard let count = datasource?.count else {
            return
        }
        var indexPath = cell.indexPath
        if  indexPath != nil{
            if indexPath!.row < (count - 1){
                indexPath!.row = indexPath!.row + 1
                tableView.selectRow(at: indexPath!, animated: true, scrollPosition: .top)
            }
        }
    }


    private func getBankCell(cell: DataEntryBankCell){
        guard
            let indexPath = cell.indexPath
        else { return }

        let bank = banks[indexPath.row]
        if
            let value = cell.textNameField.text,
            !value.isEmpty
        {
            bank.name = value.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        if
            let value = cell.textIbanField.text,
            !value.isEmpty
        {
            bank.iban = value.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        if
            let value = cell.textSwiftField.text,
            !value.isEmpty
        {
            bank.swift = value.trimmingCharacters(in: CharacterSet.whitespaces)
        }
        banks.replace(index: indexPath.row, object: bank)
    }



}

//MARK: - PickerDataEntryTextFiledCellDelegate
extension AddSuppliersViewController: PickerDataEntryTextFiledCellDelegate{
    func pickerDataEntryTextFiledDidSelected(cell: PickerDataEntryTextFiledCell, value: String?) {

        if
            let selectedValue = cell.pickerTextView.selectedValue,
            !selectedValue.isEmpty,
            let fieldInfo = cell.fieldInfo,
            let fieldName = fieldInfo["source"] as? String
        {
            supplier[fieldName] = selectedValue.trimmingCharacters(in: CharacterSet.whitespaces)
            if fieldName == "department"{
                StorageManager.sharedInstance.getDefaultRealm { (realm) in
                    self.department = realm.objects(Department.self).first(where: {$0.name == value!})
                    if let departimentName = self.department?.name{
                        self.categories = realm.objects(Category.self).filter("ANY department.name == %@", departimentName)
                        if var indexPath = cell.indexPath {
                            indexPath.row += 1
                            if
                                let cell = self.tableView.cellForRow(at: indexPath) as? PickerDataEntryTextFiledCell,
                                let selectedValue = cell.pickerTextView.selectedValue,
                                selectedValue.isEmpty
                            {
                                // se la categoria non è valorizzata allora ricarico i dati
                                self.tableView.reloadRows(at: [indexPath], with: .automatic)

                            }
                        }
                    }
                }
            }
            if fieldName == "category"{
                StorageManager.sharedInstance.getDefaultRealm { (realm) in
                    self.category = realm.objects(Category.self).first(where: {$0.name == value!})
                    if let categoryName = self.category?.name{
                        self.departments = realm.objects(Department.self).filter("ANY categories.name == %@", categoryName)
                        if var indexPath = cell.indexPath {
                            indexPath.row -= 1
                            if
                                let cell = self.tableView.cellForRow(at: indexPath) as? PickerDataEntryTextFiledCell,
                                let selectedValue = cell.pickerTextView.selectedValue,
                                selectedValue.isEmpty
                            {
                                // se i dipartimenti non è valorizzata allora ricarico i dati
                                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                            }
                        }

                    }
                }
            }
        }

    }


}
