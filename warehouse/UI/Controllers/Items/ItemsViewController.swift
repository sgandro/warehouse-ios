//
//  ItemsViewController.swift
//  warehouse
//
//  Created by Alessandro Perna on 18/10/2020.
//

import UIKit
import SideMenuSwift
import RealmSwift

class ItemsViewController: BaseTableViewController {

    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var searchBar:UISearchBar!
    
    var notificationToken: NotificationToken?
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
        isKeyboardNotificationEnabled = true
        tableSettings()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadContent()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        notificationToken?.invalidate()
    }

    deinit {
        notificationToken?.invalidate()
    }

    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.

        if
            let vc = segue.destination as? AddItemsViewController,
            let item = sender as? Item
        {
            vc.itemToUpdate = item
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

    
    //MARK: - Actions
    @IBAction func openMenuButtonPressed(button: UIBarButtonItem){
        self.sideMenuController?.revealMenu()
    }

    @IBAction func unwind( _ segue: UIStoryboardSegue) {
    }


    //MARK: - Method

    private func tableSettings(){

        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .singleLine
        tableView.alwaysBounceVertical = false
        tableView.bounces = false

        emptyStateView.labelMessage.text = "Non ci sono articoli in Archivio"
        tableView.backgroundView = emptyStateView

        //tableView.register(MenuItemCell.nibName, forCellReuseIdentifier: MenuItemCell.identifier)

    }

    //MARK: - Load Content
    private func loadContent(){

        StorageManager.sharedInstance.getDefaultRealm { (realm) in
            self.datasource = realm.objects(Item.self)
        }
    }

}

//MARK: - Table datasource
extension ItemsViewController : UITableViewDataSource{
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
        guard let datasource = self.datasource else { return UITableViewCell() }

        let category = datasource[indexPath.row].categories.first
        let department = category?.department.first

        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        cell.textLabel?.text = datasource[indexPath.row].name
        cell.detailTextLabel?.text = "\(category?.name ?? "") - \(department?.name ?? "")"
        cell.accessoryType = .disclosureIndicator
        return cell
    }

}

//MARK: - Table delegate
extension ItemsViewController : UITableViewDelegate{

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let datasource = self.datasource else { return }

        if editingStyle == .delete {
            self.showAlertWithCancel(title: "Attenzione", andBody: "Vuoi eliminare l'articolo?") { (done) in

                if done{

                    StorageManager.sharedInstance.getDefaultRealm { (realm) in
                        if let category = realm.objects(Item.self).first(where: { $0.id == datasource[indexPath.row].id }){
                            realm.beginWrite()
                            realm.delete(category)
                            do{
                                try realm.commitWrite()
                            }catch{
                                realm.cancelWrite()
                            }
                        }
                    }
                }

            }
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let datasource = self.datasource else { return }
        let item = datasource[indexPath.row]
        performSegue(withIdentifier: "segueItemEntry", sender: item)
    }
}
