//
//  MainViewController.swift
//  warehouse
//
//  Created by Alessandro Perna on 16/10/2020.
//

import UIKit
import SideMenuSwift

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

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

}
