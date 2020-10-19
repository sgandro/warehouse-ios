//
//  AddCategorieViewController.swift
//  warehouse
//
//  Created by Alessandro Perna on 18/10/2020.
//

import UIKit

class AddCategorieViewController: UIViewController {

    @IBOutlet weak var labelTitle:UILabel!
    @IBOutlet weak var labelDescription:UILabel!
    @IBOutlet weak var textFieldCategoryName:UITextField!
    @IBOutlet weak var textFieldDepartmentName:PickerTextView!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        labelTitle.initialize(textValue: "Nuova Categoria",
                              font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold),
                              color: UIColor.darkGray,
                              align: .center)

        labelDescription.initialize(textValue: "Inserie il nome della nuova caregoria.\nOgni categoria va associata ad un reparto.\nVerificare di aver precedentemente inserito il reparto desiderato",
                                    font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light),
                                    color: UIColor.blue,
                                    align: .center)

        textFieldCategoryName.placeholder = "Nome categoria"
        textFieldDepartmentName.placeholder = "Seleziona reparto"

        StorageManager.sharedInstance.getDefaultRealm { (realm) in
            self.textFieldDepartmentName.datasource = realm.objects(Department.self).map({$0.name})
        }

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

            if let department = realm.objects(Department.self).first{
                realm.beginWrite()
                let category = realm.create(Category.self, value: ["name":categoryName], update: .all)
                department.categories.append(category)
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
