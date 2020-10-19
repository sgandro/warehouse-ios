//
//  ItemsViewController.swift
//  warehouse
//
//  Created by Alessandro Perna on 18/10/2020.
//

import UIKit
import SideMenuSwift
import RealmSwift

class ItemsViewController: UIViewController {

    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var searchBar:UISearchBar!
    
    var notificationToken: NotificationToken?
    var datasource:Results<Item>?{

        didSet{

            if let datasource = datasource {
                if notificationToken != nil { notificationToken?.invalidate() }
                notificationToken = datasource.observe({ [weak self] (changes) in
                    guard let tableView = self?.tableView else { return }

                    switch changes {
                    case .initial:
                        tableView.reloadData()

                    case .update( _, deletions: let deletions, insertions: let insertions, modifications: let updates):

                        tableView.beginUpdates()
                        tableView.insertRows(at: insertions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                        tableView.reloadRows(at: updates.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                        tableView.deleteRows(at: deletions.map({IndexPath(row: $0, section: 0)}), with: .automatic)
                        tableView.endUpdates()

                    case .error(let error): fatalError("\(error)")
                    }

                })
            }
        }
    }

    let emptyStateView = EmptyStateView()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        cell.textLabel?.text = datasource[indexPath.row].name
        return cell
    }

}

//MARK: - Table delegate
extension ItemsViewController : UITableViewDelegate{}
