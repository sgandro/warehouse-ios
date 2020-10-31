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
    @IBOutlet weak var tableView:UITableView!

    var itemToUpdate:Item?
    var item:[String:Any] = [:]
    var datasource:[[String:Any]]?

    private var category:Category?
    private var department:Department?
    private var categories:Results<Category>?
    private var departments:Results<Department>?

    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true

        // Do any additional setup after loading the view.
        loadCategories()
        loadDepartiments()
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

        if itemToUpdate != nil{

            labelTitle.initialize(textValue: "Modifica Articolo", font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold), color: UIColor.darkGray, align: .center)

            labelDescription.initialize(textValue: "Puoi modificare l'articolo, ma non puoi modificare la categoria di appartenenza",
                                        font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light),
                                        color: UIColor.secondaryLabel,
                                        align: .center)

        }else{
            labelTitle.initialize(textValue: "Nuovo Articolo", font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold), color: UIColor.darkGray, align: .center)

            labelDescription.initialize(textValue: "Prima di inserire i dati è necessario creare un reparto e una categoria a cui associare il prodotto",
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
        datasource = TableConfigurator.getPlistFile(root:"fields", resourceName: "itemFields")

    }

    func loadCategories(){
        StorageManager.sharedInstance.getDefaultRealm { (realm) in
            if let departimentName = self.department?.name{
                self.categories = realm.objects(Category.self).filter("ANY department.name == %@", departimentName)
            }else{
                self.categories = realm.objects(Category.self)
            }
            let count = self.categories?.count ?? 0
            if count == 0{
                self.showAlert(title: "Informazione", andBody: "Creare prima una categoria")
            }
        }
    }

    func loadDepartiments(){
        StorageManager.sharedInstance.getDefaultRealm { (realm) in
            if let categoryName = self.category?.name{
                self.departments = realm.objects(Department.self).filter("ANY categories.name == %@", categoryName)
            }else{
                self.departments = realm.objects(Department.self)
            }

            let count = self.departments?.count ?? 0
            if count == 0{
                self.showAlert(title: "Informazione", andBody: "Creare prima un reparto")
            }

        }

    }

    //MARK: - Action
    @IBAction func closeButtonPressed(button:UIButton){
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveButtonPressed(button:UIButton){


        StorageManager.sharedInstance.getDefaultRealm { (realm) in

            if
                let categoryName = self.item["category"] as? String,
                let category = realm.objects(Category.self).first(where: {$0.name == categoryName})
            {
                realm.beginWrite()

                if let itemToUpdate = self.itemToUpdate{

                    itemToUpdate.name = self.item["name"] as? String ?? ""
                    itemToUpdate.serialNumber = self.item["serialNumber"] as? String ?? ""
                    itemToUpdate.barcode = self.item["barcode"] as? String ?? ""
                    itemToUpdate.price = self.item["price"] as? Double ?? 0.0
                    itemToUpdate.unitPrice = self.item["unitPrice"] as? Double ?? 0.0
                    itemToUpdate.unit = self.item["unit"] as? String ?? ""
                    itemToUpdate.quantity = self.item["quantity"] as? Int ?? 0
                    itemToUpdate.vat = self.item["vat"] as? Double ?? 0.0
                    itemToUpdate.note = self.item["note"] as? String ?? ""
                    itemToUpdate.minimumStock = self.item["minimumStock"] as? Int ?? 0
                    realm.add(category, update: .modified)

                }else{

                    let newItem = realm.create(Item.self, value: self.item, update: .all)
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



}



//MARK : - Table
extension AddItemsViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let datasource = self.datasource else {
            return UITableViewCell()
        }

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
                case "picker":

                    let cell = tableView.dequeueReusableCell(withIdentifier: PickerDataEntryTextFiledCell.identifier, for: indexPath) as! PickerDataEntryTextFiledCell

                    cell.caption = field["caption"] as? String
                    cell.indexPath = indexPath
                    cell.delegate = self
                    cell.fieldInfo = field

                    if itemToUpdate != nil{

                        if let source = field["source"] as? String{

                            switch source {
                                case "department":
                                    if let departmentName = self.itemToUpdate?.categories.first?.department.first?.name{
                                        cell.pickerTextView.datasource = [departmentName]
                                    }
                                case "category":
                                    if let categoryName = itemToUpdate?.categories.first?.name{
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
        return UITableViewCell()
    }
}


//MARK: - DataEntryTextFiledCellDelegate
extension AddItemsViewController: DataEntryTextFiledCellDelegate{
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


//MARK: - PickerDataEntryTextFiledCellDelegate
extension AddItemsViewController: PickerDataEntryTextFiledCellDelegate{
    func pickerDataEntryTextFiledDidSelected(cell: PickerDataEntryTextFiledCell, value: String?) {

        if
            let selectedValue = cell.pickerTextView.selectedValue,
            !selectedValue.isEmpty,
            let fieldInfo = cell.fieldInfo,
            let fieldName = fieldInfo["field"] as? String
        {
            item[fieldName] = selectedValue.trimmingCharacters(in: CharacterSet.whitespaces)
            if fieldName == "department"{
                StorageManager.sharedInstance.getDefaultRealm { (realm) in
                    self.department = realm.objects(Department.self).first(where: {$0.name == value!})
                    self.loadDepartiments()
                    self.tableView.reloadRows(at: [cell.indexPath!], with: .automatic)
                }
            }
            if fieldName == "category"{
                StorageManager.sharedInstance.getDefaultRealm { (realm) in
                    self.category = realm.objects(Category.self).first(where: {$0.name == value!})
                    self.loadCategories()
                    self.tableView.reloadRows(at: [cell.indexPath!], with: .automatic)
                }
            }
        }

    }


}
