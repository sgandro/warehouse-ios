//
//  AddCategorieViewController.swift
//  warehouse
//
//  Created by Alessandro Perna on 18/10/2020.
//

import UIKit
import RealmSwift

class AddCategorieViewController: UIViewController {

    @IBOutlet weak var labelTitle:UILabel!
    @IBOutlet weak var labelDescription:UILabel!
    @IBOutlet weak var tableView:UITableView!

    var categoryToUpdate:Category?
    var category:[String:Any] = [:]
    var datasource:[[String:Any]]?

    override func viewDidLoad() {
        super.viewDidLoad()

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

        if categoryToUpdate != nil{

            labelTitle.initialize(textValue: "Modifica Categoria",
                                  font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold),
                                  color: UIColor.darkGray,
                                  align: .center)

            labelDescription.initialize(textValue: "Modifica il nome della caregoria.\nOgni categoria va associata ad un reparto.\nPuoi cambiare il reparto a cui è associata la categoria.",
                                        font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light),
                                        color: UIColor.secondaryLabel,
                                        align: .center)
        }else{

            labelTitle.initialize(textValue: "Nuova Categoria",
                                  font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold),
                                  color: UIColor.darkGray,
                                  align: .center)

            labelDescription.initialize(textValue: "Inserie il nome della nuova caregoria.\nOgni categoria va associata ad un reparto.\nVerificare di aver precedentemente inserito il reparto desiderato",
                                        font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light),
                                        color: UIColor.secondaryLabel,
                                        align: .center)
        }

    }

    //MARK: - Action
    @IBAction func closeButtonPressed(button:UIButton){
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveButtonPressed(button:UIButton){

        self.view.endEditing(true)

        guard let categoryName = self.category["name"] as? String else {
            return
        }
        guard let departmentName = self.category["department"] as? String else {
            return
        }

        StorageManager.sharedInstance.getDefaultRealm { (realm) in

            if let department = realm.objects(Department.self).first(where: {$0.name == departmentName}){
                realm.beginWrite()
                if let category = self.categoryToUpdate{

                    category.name = categoryName
                    realm.add(category, update: .modified)

                }else{
                    let category = realm.create(Category.self, value: ["name":categoryName], update: .all)
                    department.categories.append(category)
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



    //MARK: - Method

    private func tableSettings(){

        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        tableView.bounces = false

        tableView.register(PickerDataEntryTextFiledCell.nibName, forCellReuseIdentifier: PickerDataEntryTextFiledCell.identifier)
        tableView.register(DataEntryTextFiledCell.nibName, forCellReuseIdentifier: DataEntryTextFiledCell.identifier)
        datasource = TableConfigurator.getPlistFile(root:"fields", resourceName: "categoryFields")

    }

}


//MARK : - Table
extension AddCategorieViewController: UITableViewDelegate, UITableViewDataSource{

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

                    if categoryToUpdate != nil{
                        if
                            let fieldName = field["field"] as? String,
                            let fieldValue = categoryToUpdate?.value(forKey: fieldName) as? String
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

                    if categoryToUpdate != nil{
                        if let source = field["source"] as? String{
                            switch source {
                                case "department":
                                    StorageManager.sharedInstance.getDefaultRealm { (realm) in
                                        cell.pickerTextView.datasource = self.categoryToUpdate?.department.map({$0.name})
                                    }
                                default:
                                    fatalError()
                            }
                        }

                    }else{
                        if let source = field["source"] as? String{
                            switch source {
                                case "department":
                                    StorageManager.sharedInstance.getDefaultRealm { (realm) in
                                        cell.pickerTextView.datasource = realm.objects(Department.self).map({$0.name})
                                        let count = cell.pickerTextView.datasource?.count ?? 0
                                        if count == 0{
                                            self.showAlert(title: "Informazione", andBody: "Creare prima un reparto")
                                        }
                                    }
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
extension AddCategorieViewController: DataEntryTextFiledCellDelegate{
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
            category[fieldName] = value.trimmingCharacters(in: CharacterSet.whitespaces)
        }

    }

    func dataEntryTextFiledDidKeyboardDone(cell: DataEntryTextFiledCell) {
        if
            let value = cell.textFieldValue.text,
            !value.isEmpty,
            let fieldInfo = cell.fieldInfo,
            let fieldName = fieldInfo["field"] as? String
        {
            category[fieldName] = value.trimmingCharacters(in: CharacterSet.whitespaces)
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
            category[fieldName] = value.trimmingCharacters(in: CharacterSet.whitespaces)
        }
    }
}


//MARK: - PickerDataEntryTextFiledCellDelegate
extension AddCategorieViewController: PickerDataEntryTextFiledCellDelegate{
    func pickerDataEntryTextFiledDidSelected(cell: PickerDataEntryTextFiledCell, value: String?) {
        if
            let value = cell.pickerTextView.selectedValue,
            !value.isEmpty,
            let fieldInfo = cell.fieldInfo,
            let fieldName = fieldInfo["field"] as? String
        {
            category[fieldName] = value.trimmingCharacters(in: CharacterSet.whitespaces)
        }
    }


}

