//
//  AddDepartmentsViewController.swift
//  warehouse
//
//  Created by Alessandro Perna on 18/10/2020.
//

import UIKit
import RealmSwift

class AddDepartmentsViewController: BaseTableViewController {

    @IBOutlet weak var labelTitle:UILabel!
    @IBOutlet weak var labelDescription:UILabel!
    @IBOutlet weak var tableView:UITableView!

    var departmentToUpdate:Department?
    var department:[String:Any] = [:]
    var datasource:[[String:Any]]?

    override func viewDidLoad() {
        super.viewDidLoad()
        isModalInPresentation = true
        isKeyboardNotificationEnabled = true

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

        if departmentToUpdate != nil{

            labelTitle.initialize(textValue: "Modifica Reparto", font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold), color: UIColor.darkGray, align: .center)

            labelDescription.initialize(textValue: "Modifica il nome del reparto.\nAd ogni reparto vanno associate le relative categorie.",
                                        font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light),
                                        color: UIColor.secondaryLabel,
                                        align: .center)


        }else{

            labelTitle.initialize(textValue: "Nuovo Reparto", font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold), color: UIColor.darkGray, align: .center)

            labelDescription.initialize(textValue: "Inserie il nome del nuovo reparto.\nAd ogni reparto vanno associate le relative categorie.",
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

        tableView.register(DataEntryTextFiledCell.nibName, forCellReuseIdentifier: DataEntryTextFiledCell.identifier)
        datasource = TableConfigurator.getPlistFile(root:"fields", resourceName: "departmentFields")

    }


    //MARK: - Action
    @IBAction func closeButtonPressed(button:UIButton){
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveButtonPressed(button:UIButton){

        self.view.endEditing(true)

        guard let departmentName = self.department["name"] as? String else {
            return
        }

        StorageManager.sharedInstance.getDefaultRealm { (realm) in

            realm.beginWrite()
            if let department = self.departmentToUpdate{
                department.name = departmentName
                realm.add(department, update: .modified)
            }else{
                realm.create(Department.self, value: ["name":departmentName], update: .all)
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

}




//MARK : - Table
extension AddDepartmentsViewController: UITableViewDelegate, UITableViewDataSource{

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
                    cell.caption = datasource[indexPath.row]["caption"] as? String
                    cell.delegate = self
                    cell.indexPath = indexPath
                    cell.fieldInfo = field

                    if departmentToUpdate != nil{
                        if
                            let fieldName = field["field"] as? String,
                            let fieldFormat = field["format"] as? String
                        {
                            switch fieldFormat {
                                case "string":
                                    cell.textFieldValue.text = departmentToUpdate?.value(forKey: fieldName) as? String
                                    cell.applayFieldFormat()
                                case "currency","percent":
                                    let doubleValue = (departmentToUpdate?.value(forKey: fieldName) as? Double) ?? 0.0
                                    cell.textFieldValue.text = "\(doubleValue)"
                                    cell.applayFieldFormat()
                                case "integer":
                                    let intValue = (departmentToUpdate?.value(forKey: fieldName) as? Int) ?? 0
                                    cell.textFieldValue.text = "\(intValue)"
                                    cell.applayFieldFormat()
                                default:
                                    fatalError()
                            }
                        }
                    }else{
                        if  let fieldName = field["source"] as? String{
                            cell.textFieldValue.text = department[fieldName] as? String
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
extension AddDepartmentsViewController: DataEntryTextFiledCellDelegate{
    func dataEntryTextFiledDidNext(cell: DataEntryTextFiledCell) {
        self.view.endEditing(true)
    }

    func dataEntryTextFiledDidCheck(cell: DataEntryTextFiledCell) {
        getTextFieldCell(cell: cell)
    }

    func dataEntryTextFiledDidKeyboardDone(cell: DataEntryTextFiledCell) {
        getTextFieldCell(cell: cell)
        self.view.endEditing(true)
    }

    func dataEntryTextFiledDidKeyboardCancel(cell: DataEntryTextFiledCell) {
        self.view.endEditing(true)
    }

    func dataEntryTextFiledDidKeyboardNext(cell: DataEntryTextFiledCell) {
        getTextFieldCell(cell: cell)
    }


    private func getTextFieldCell(cell: DataEntryTextFiledCell){
        if
            let value = cell.textFieldValue.text,
            !value.isEmpty,
            let fieldInfo = cell.fieldInfo,
            let fieldName = fieldInfo["field"] as? String
        {
            department[fieldName] = value.trimmingCharacters(in: CharacterSet.whitespaces)
        }
    }

}


