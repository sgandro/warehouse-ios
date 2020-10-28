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

    @IBOutlet weak var labelCaptionCategoryName:UILabel!
    @IBOutlet weak var textFieldCategoryName:UITextField!

    @IBOutlet weak var labelCaptionDepartmentName:UILabel!
    @IBOutlet weak var textFieldDepartmentName:PickerTextView!

    var categoryToUpdate:Category?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

            textFieldCategoryName.delegate = self
            textFieldCategoryName.returnKeyType = .next
            textFieldCategoryName.text = categoryToUpdate?.name
            textFieldCategoryName.inputAccessoryView = keyboardToolBar

            textFieldDepartmentName.delegate = self
            textFieldDepartmentName.returnKeyType = .next

            StorageManager.sharedInstance.getDefaultRealm { (realm) in
                self.textFieldDepartmentName.datasource = self.categoryToUpdate?.department.map({$0.name})
            }

        }else{

            labelTitle.initialize(textValue: "Nuova Categoria",
                                  font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold),
                                  color: UIColor.darkGray,
                                  align: .center)

            labelDescription.initialize(textValue: "Inserie il nome della nuova caregoria.\nOgni categoria va associata ad un reparto.\nVerificare di aver precedentemente inserito il reparto desiderato",
                                        font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light),
                                        color: UIColor.secondaryLabel,
                                        align: .center)

            textFieldCategoryName.delegate = self
            textFieldCategoryName.returnKeyType = .next
            textFieldCategoryName.inputAccessoryView = keyboardToolBar

            textFieldDepartmentName.delegate = self
            textFieldDepartmentName.returnKeyType = .next

            textFieldDepartmentName.placeholder = "Seleziona reparto"
            StorageManager.sharedInstance.getDefaultRealm { (realm) in
                self.textFieldDepartmentName.datasource = realm.objects(Department.self).map({$0.name})
                let count = self.textFieldDepartmentName.datasource?.count ?? 0
                if count == 0{
                    self.showAlert(title: "Informazione", andBody: "Creare prima un reparto")
                }

            }


        }

        labelCaptionCategoryName.initialize(textValue: "Categoria",
                                            font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                            color: UIColor.secondaryLabel,
                                            align: .left)

        labelCaptionDepartmentName.initialize(textValue: "Dipartimento",
                                              font: UIFont.systemFont(ofSize: 12, weight: .semibold),
                                              color: UIColor.secondaryLabel,
                                              align: .left)




    }

    //MARK: - Action
    @IBAction func closeButtonPressed(button:UIButton){
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveButtonPressed(button:UIButton){

        guard
            let categoryName = textFieldCategoryName.text,
            categoryName.isEmpty == false
        else {
            requestAttention(to: textFieldCategoryName)
            return
        }

        guard
            textFieldDepartmentName.text?.isEmpty == false,
            let departmentName = textFieldDepartmentName.selectedValue,
            departmentName.isEmpty == false
        else {
            requestAttention(to: textFieldDepartmentName)
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
}


extension AddCategorieViewController:UITextFieldDelegate{

    func textFieldDidEndEditing(_ textField: UITextField) {
        checkFields(textField)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextFieldMove()
        return true
    }

    func nextFieldMove(){

        let fields: [UITextField] = [textFieldCategoryName,
                                     textFieldDepartmentName]

        if
            let activeField: UITextField = fields.first(where: { $0.isFirstResponder }),
            let index: Int = fields.firstIndex(of: activeField)
        {
            let lastIndex = (index < fields.count) ? index:(fields.count - 1)
            let nextField: UITextField = fields[fields.index(after: lastIndex)]
            nextField.becomeFirstResponder()
        }

    }

    func checkFields(_ textField: UITextField){

        if textField == textFieldCategoryName {}
        if textField == textFieldDepartmentName {}

    }


}
