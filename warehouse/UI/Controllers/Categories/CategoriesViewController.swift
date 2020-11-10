//
//  CategoriesViewController.swift
//  warehouse
//
//  Created by Alessandro Perna on 18/10/2020.
//

import UIKit
import SideMenuSwift
import RealmSwift

class CategoriesViewController: BaseTableViewController {

    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var searchBar:UISearchBar!

    var notificationToken: NotificationToken?
    var datasource:Results<Category>?{
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
            let vc = segue.destination as? AddCategorieViewController,
            let category = sender as? Category
        {
            vc.categoryToUpdate = category
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

    //MARK: - Method

    private func tableSettings(){

        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .singleLine
        tableView.alwaysBounceVertical = false
        tableView.bounces = false

        emptyStateView.labelMessage.text = "Non ci sono categorie in Archivio"
        tableView.backgroundView = emptyStateView


    }

    //MARK: - Load Content
    private func loadContent(){

        StorageManager.sharedInstance.getDefaultRealm { (realm) in
            self.datasource = realm.objects(Category.self)
        }
    }



}

//MARK: - Table datasource
extension CategoriesViewController : UITableViewDataSource{
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        cell.textLabel?.text = datasource[indexPath.row].name
        cell.detailTextLabel?.text = datasource[indexPath.row].department.first?.name
        return cell
    }
}

//MARK: - Table delegate
extension CategoriesViewController : UITableViewDelegate{

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let datasource = self.datasource else { return }

        if editingStyle == .delete {
            self.showAlertWithCancel(title: "Attenzione", andBody: "Vuoi eliminare la categoria?") { (done) in

                if done{

                    StorageManager.sharedInstance.getDefaultRealm { (realm) in
                        if let category = realm.objects(Category.self).first(where: { $0.id == datasource[indexPath.row].id }){
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
        let category = datasource[indexPath.row]
        self.performSegue(withIdentifier: "segueCategoryEntry", sender: category)
    }
}

