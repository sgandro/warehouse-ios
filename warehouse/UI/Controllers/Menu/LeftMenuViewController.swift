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
    @IBOutlet weak var APP_VERSION:UILabel!

    typealias MenuItem = (title: String, icon: UIImage?, identifier: String?, with: String?)
    typealias MenuHeader = (title: String, items: [MenuItem]?)
    var menuItems: [MenuHeader] = [MenuHeader]()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableSettings()
        menuItemSettings()
        APP_VERSION.text = "Ver. \(BUNDLE_VERSION.version)"
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
    private func getMenuFromPlist()->[[String:Any]]?{

        guard
            let path = Bundle.main.path(forResource: "menu", ofType: "plist", inDirectory: nil)
        else { return nil }

        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)

        guard
            let plist = try! PropertyListSerialization.propertyList(from: data,
                                                                      options: .mutableContainers,
                                                                      format: nil) as? [String:Any]
        else { return nil }

        return plist["menu"] as? [[String:Any]]

    }


    private func menuItemSettings(){

        if let menu = getMenuFromPlist(){

            menu.forEach { (item) in

                if
                    let title = item["title"] as? String,
                    let subMenu = item["submenu"] as? [[String:Any]]
                {
                    var menuHeader = MenuHeader(title,[])
                    subMenu.forEach { (subMenuItem) in
                        if
                            let title = subMenuItem["title"] as? String,
                            let alias = subMenuItem["alias"] as? String,
                            let controller = subMenuItem["controller"] as? String{

                            let menuItem = MenuItem(title,UIImage(named: "menu"),controller,alias)
                            menuHeader.items?.append(menuItem)
                        }

                    }
                    menuItems.append(menuHeader)
                }
            }
        }


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

