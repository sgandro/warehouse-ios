//
//  AddDepartmentsViewController.swift
//  warehouse
//
//  Created by Alessandro Perna on 18/10/2020.
//

import UIKit

class AddDepartmentsViewController: UIViewController {

    @IBOutlet weak var labelTitle:UILabel!
    @IBOutlet weak var labelDescription:UILabel!
    @IBOutlet weak var textFieldDepartmentName:UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        labelTitle.initialize(textValue: "Nuovo Reparto", font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold), color: UIColor.darkGray, align: .center)

        labelDescription.initialize(textValue: "Inserie il nome del nuovo reparto.\nAd ogni reparto vanno associate le relative categorie.",
                                    font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light),
                                    color: UIColor.blue,
                                    align: .center)

        textFieldDepartmentName.placeholder = "Nome reparto"
    }


    //MARK: - Action
    @IBAction func closeButtonPressed(button:UIButton){
        dismiss(animated: true, completion: nil)
    }
    @IBAction func saveButtonPressed(button:UIButton){

        guard let stringValue = textFieldDepartmentName.text, stringValue.isEmpty == false else {
            requestAttention(to: textFieldDepartmentName)
            return
        }

        StorageManager.sharedInstance.getDefaultRealm { (realm) in

            realm.beginWrite()
            realm.create(Department.self, value: ["name":stringValue], update: .all)
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
