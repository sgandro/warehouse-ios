//
//  ItemForOrderViewController.swift
//  warehouse
//
//  Created by Alessandro Perna on 06/11/2020.
//

import UIKit
import RealmSwift

class ItemForOrderViewController: UIViewController {

    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var searchBar:UISearchBar!

    @IBOutlet weak var labelCaptionSupplier:UILabel!
    @IBOutlet weak var labelCaptionDepartment:UILabel!
    @IBOutlet weak var labelCaptionCategory:UILabel!

    @IBOutlet weak var labelSupplier:UILabel!
    @IBOutlet weak var labelDepartment:UILabel!
    @IBOutlet weak var labelCategory:UILabel!

    var supplier:Supplier?
    var category:Category?
    var notificationToken: NotificationToken?
    var order:Order?

    var datasource:Results<Item>?{
        didSet{
            if let datasource = datasource {
                notificationToken = datasource.observe(tableView.applayChanges)
            }
        }
    }
    let emptyStateView = EmptyStateView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableSettings()
        loadContent()
        isModalInPresentation = false
        self.navigationController?.presentationController?.delegate = self


    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        labelCaptionSupplier.initialize(textValue: "Fornitore",
                                        font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold),
                                        color: UIColor.darkGray,
                                        align: .left)

        labelCaptionDepartment.initialize(textValue: "Reparto",
                                          font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold),
                                          color: UIColor.darkGray,
                                          align: .left)

        labelCaptionCategory.initialize(textValue: "Categoria",
                                        font: UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold),
                                        color: UIColor.darkGray,
                                        align: .left)

        labelSupplier.initialize(textValue: self.category?.suppliers.first?.businessName,
                                 font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular),
                                 color: UIColor.darkGray,
                                 align: .left)

        labelDepartment.initialize(textValue: self.category?.department.first?.name,
                                   font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular),
                                   color: UIColor.darkGray,
                                   align: .left)

        labelCategory.initialize(textValue: self.category?.name,
                                 font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular),
                                 color: UIColor.darkGray,
                                 align: .left)


    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        StorageManager.sharedInstance.beginRealmSession()
        self.order = Order()

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
        dismiss(animated: true, completion: nil)
    }

    //MARK: - Load Content
    private func loadContent(){

        StorageManager.sharedInstance.getDefaultRealm { (realm) in
            if let categoryId = self.category?.id{
                self.datasource = realm.objects(Item.self).filter("ANY categories.id = %@", categoryId)
            }
        }
    }



    //MARK: - Methods
    private func tableSettings(){

        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clear
        tableView.alwaysBounceVertical = false
        tableView.bounces = false
        tableView.register(ItemForOrderCell.nibName, forCellReuseIdentifier: ItemForOrderCell.identifier)

        emptyStateView.labelMessage.text = "Non ci sono articoli in Archivio\nassociati alla categoria selezionata"
        tableView.backgroundView = emptyStateView

    }


}

//MARK: - TableView
extension ItemForOrderViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let datasource = self.datasource else {
            tableView.backgroundView = emptyStateView
            return 0
        }
        if datasource.count == 0{
            tableView.backgroundView = emptyStateView
        }else{
            tableView.backgroundView = nil
        }
        return datasource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let datasource = self.datasource else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemForOrderCell.identifier, for: indexPath) as! ItemForOrderCell
        cell.item = datasource[indexPath.row]
        cell.updateOrder = {(item) in
            if item != nil && self.order != nil {
                if let index = self.order!.items.index(of: item!){
                    self.order!.items.replace(index: index, object: item!)
                }else{
                    self.order!.items.append(item!)
                }
                print("order:\(self.order!)")
            }

        }
        return cell
    }
}


extension ItemForOrderViewController: UIAdaptivePresentationControllerDelegate{
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print(#function)
        StorageManager.sharedInstance.cancelRealmSession()
    }
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        print(#function)
        return true
    }

    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        print(#function)
    }

}
