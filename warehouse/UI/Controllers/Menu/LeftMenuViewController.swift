//
//  LeftMenuViewController.swift
//  warehouse
//
//  Created by Alessandro Perna on 16/10/2020.
//

import UIKit
import SideMenuSwift

class LeftMenuViewController: UIViewController {

    @IBOutlet weak var tableView:UITableView!

    typealias MenuItem = (title: String, icon: UIImage?, identifier: String?, with: String?)
    typealias MenuHeader = (title: String, items: [MenuItem]?)
    var menuItems: [MenuHeader] = [MenuHeader]()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableSettings()
        menuItemSettings()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: - Method

    private func tableSettings(){

        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        tableView.bounces = false
        tableView.register(MenuItemCell.nibName, forCellReuseIdentifier: MenuItemCell.identifier)

    }
    private func menuItemSettings(){

        //Creazione del menu
        menuItems.append(MenuHeader("Principale", [
            MenuItem("Dashboard",UIImage(named: "menu"),"MainViewController","dashboard"),
        ]))

        menuItems.append(MenuHeader("Cambusa", [
            MenuItem("Reparti",UIImage(named: "menu"), "DepartmentsViewController", "departments"),
            MenuItem("Categorie",UIImage(named: "menu"), "CategoriesViewController", "categories"),
            MenuItem("Articoli",UIImage(named: "menu"), "ItemsViewController", "items"),
            MenuItem("Unità di Misura",UIImage(named: "menu"), "UnitsViewController", "items"),
        ]))

        menuItems.append(MenuHeader("Gestione", [
            MenuItem("Fornitori",UIImage(named: "menu"), "SuppliersViewController", "suppliers"),
            MenuItem("Banche",UIImage(named: "menu"), "BanksViewController", "banks"),
            MenuItem("Clienti",UIImage(named: "menu"), "ClientsViewController", "clients"),
        ]))

        sideMenuController?.delegate = self


    }

}

//MARK: - Table datasource
extension LeftMenuViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuItems.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems[section].items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuItemCell.identifier, for: indexPath) as! MenuItemCell
        cell.labelTitle.text = menuItems[indexPath.section].items?[indexPath.row].title
        cell.imageViewIcon.image = menuItems[indexPath.section].items?[indexPath.row].icon
        cell.imageViewIcon.isHidden = true

        if
            let identifier = menuItems[indexPath.section].items?[indexPath.row].identifier,
            let with = menuItems[indexPath.section].items?[indexPath.row].with
        {
            sideMenuController?.cache(viewControllerGenerator: { self.storyboard?.instantiateViewController(withIdentifier: identifier) }, with: with)
        }

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MenuItemCell
        cell.imageViewIcon.isHidden = false

        if let with = menuItems[indexPath.section].items?[indexPath.row].with {
            sideMenuController?.setContentViewController(with: with)
            sideMenuController?.hideMenu()
        }

    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MenuItemCell
        cell.imageViewIcon.isHidden = true
    }
}

//MARK: - Table delegate
extension LeftMenuViewController: UITableViewDelegate{

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let view = MenuHeaderView()
        view.lblTitle.text = menuItems[section].title
        return view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return MenuHeaderView.height
    }
}

extension LeftMenuViewController: SideMenuControllerDelegate{

    func sideMenuController(_ sideMenuController: SideMenuController,
                            animationControllerFrom fromVC: UIViewController,
                            to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BasicTransitionAnimator(options: .transitionFlipFromLeft, duration: 0.6)
    }

    func sideMenuController(_ sideMenuController: SideMenuController, willShow viewController: UIViewController, animated: Bool) {
        print("[Example] View controller will show [\(viewController)]")
    }

    func sideMenuController(_ sideMenuController: SideMenuController, didShow viewController: UIViewController, animated: Bool) {
        print("[Example] View controller did show [\(viewController)]")
    }

    func sideMenuControllerWillHideMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu will hide")
    }

    func sideMenuControllerDidHideMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu did hide.")
    }

    func sideMenuControllerWillRevealMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu will reveal.")
    }

    func sideMenuControllerDidRevealMenu(_ sideMenuController: SideMenuController) {
        print("[Example] Menu did reveal.")
    }
}

