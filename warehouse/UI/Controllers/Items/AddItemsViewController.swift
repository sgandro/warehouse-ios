//
//  AddItemsViewController.swift
//  warehouse
//
//  Created by Alessandro Perna on 25/10/2020.
//

import UIKit

class AddItemsViewController: UIViewController {

    @IBOutlet weak var labelTitle:UILabel!
    @IBOutlet weak var labelDescription:UILabel!

    @IBOutlet weak var labelCaptionName:UILabel!
    @IBOutlet weak var textFieldName:UITextField!

    @IBOutlet weak var labelCaptionSerialNumber:UILabel!
    @IBOutlet weak var textFieldSerialNumber:UITextField!

    @IBOutlet weak var labelCaptionBarcode:UILabel!
    @IBOutlet weak var textFieldBarcode:UITextField!

    var item:[String:Any]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        labelTitle.initialize(textValue: "Nuovo Articolo", font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold), color: UIColor.darkGray, align: .center)

        labelDescription.initialize(textValue: "Inserie il nuovo prodotto in tre passaggi. Il numero seriale e il codice a barre sono campi obbligatori",
                                    font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light),
                                    color: UIColor.secondaryLabel,
                                    align: .center)

        labelCaptionName.initialize(textValue: "Nome",
                                    font: UIFont.systemFont(ofSize: 18, weight: .semibold),
                                    color: UIColor.secondaryLabel,
                                    align: .left)

        labelCaptionSerialNumber.initialize(textValue: "Serial number",
                                            font: UIFont.systemFont(ofSize: 18, weight: .semibold),
                                            color: UIColor.secondaryLabel,
                                            align: .left)

        labelCaptionBarcode.initialize(textValue: "Barcode",
                                       font: UIFont.systemFont(ofSize: 18, weight: .semibold),
                                       color: UIColor.secondaryLabel,
                                       align: .left)



    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: - Action
    @IBAction func closeButtonPressed(button:UIButton){
        performSegue(withIdentifier: "unwindToArticle", sender: self)
    }
    @IBAction func saveButtonPressed(button:UIButton){
        dismiss(animated: true, completion: nil)
    }


}
