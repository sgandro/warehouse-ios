//
//  AddItemsViewController.swift
//  warehouse
//
//  Created by Alessandro Perna on 18/10/2020.
//

import UIKit

class AddItemsThirdStepViewController: UIViewController {

    @IBOutlet weak var labelTitle:UILabel!
    @IBOutlet weak var labelDescription:UILabel!
    @IBOutlet weak var textFieldMinimumStock:UITextField!
    @IBOutlet weak var textFieldCategoryName:PickerTextView!

    var item:[String:Any]?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        labelTitle.initialize(textValue: "Nuovo Articolo", font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold), color: UIColor.darkGray, align: .center)

        labelDescription.initialize(textValue: "La categoria è un campo obbligatorio per l'associazione del prodotto",
                                    font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light),
                                    color: UIColor.secondaryLabel,
                                    align: .center)

        textFieldMinimumStock.placeholder = "Scorta minuma"
        textFieldCategoryName.placeholder = "Seleziona la categoria"
        StorageManager.sharedInstance.getDefaultRealm { (realm) in
            self.textFieldCategoryName.datasource = realm.objects(Category.self).map({$0.name})
        }


    }



    //MARK: - Action
    @IBAction func closeButtonPressed(button:UIButton){
        performSegue(withIdentifier: "unwindToArticle", sender: self)
    }
    @IBAction func saveButtonPressed(button:UIButton){

        guard
            let minimumStockValue = textFieldMinimumStock.text,
            minimumStockValue.isEmpty == false,
            let minimumStockInteger = Int(minimumStockValue)
        else {
            requestAttention(to: textFieldMinimumStock)
            return
        }
        guard
            let categoryNameValue = textFieldCategoryName.selectedValue,
            categoryNameValue.isEmpty == false
        else {
            requestAttention(to: textFieldCategoryName)
            return
        }

        item?["minimumStock"] = minimumStockInteger

        if let item = self.item{

            StorageManager.sharedInstance.getDefaultRealm { (realm) in

                if let category = realm.objects(Category.self).first(where: {$0.name == categoryNameValue}){
                    realm.beginWrite()
                    let newItem = realm.create(Item.self, value: item, update: .all)
                    category.items.append(newItem)
                    do{
                        try realm.commitWrite()
                    }catch{
                        realm.cancelWrite()
                        print("Error:\(error.localizedDescription)")
                    }

                }

            }
        }



        dismiss(animated: true, completion: nil)
    }

}

extension AddItemsThirdStepViewController: UITextFieldDelegate{

    func textFieldDidEndEditing(_ textField: UITextField) {

        if textField == textFieldMinimumStock {
            if
                let text = textField.text,
                let integerValue = Int(text)
            {
                let formatter = NumberFormatter()
                formatter.numberStyle = .ordinal
                formatter.locale = Locale(identifier: "it_IT")
                textField.text = formatter.string(from: NSNumber(value: integerValue))
            }else{
                requestAttention(to: textFieldMinimumStock)
            }
        }
        if textField == textFieldCategoryName {}

    }
}
