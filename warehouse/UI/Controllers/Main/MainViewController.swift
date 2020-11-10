//
//  MainViewController.swift
//  warehouse
//
//  Created by Alessandro Perna on 16/10/2020.
//

import UIKit
import SideMenuSwift
import RealmSwift

class MainViewController: UIViewController {

    @IBOutlet weak var labelTitleOrder:UILabel!
    @IBOutlet weak var collectionViewOrder:UICollectionView!

    var datasourceOrders:Results<Order>?{
        didSet{
            if let datasourceOrders = datasourceOrders {
                notificationToken = datasourceOrders.observe(collectionViewOrder.applayChanges)
            }
        }
    }
    var notificationToken: NotificationToken?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        settings()
    }
    
   

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }


    //MARK: - Actions
    @IBAction func openMenuButtonPressed(button: UIBarButtonItem){
        self.sideMenuController?.revealMenu()
    }

    //MARK: - Methods
    func settings(){

        labelTitleOrder.initialize(textValue: "Ordini",
                              font: UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold),
                              color: UIColor.darkGray,
                              align: .left)

        collectionViewSettings()
    }
    func collectionViewSettings(){
        collectionViewOrder.register(OrderBigCell.nibName, forCellWithReuseIdentifier: OrderBigCell.identifier)
        collectionViewOrder.register(PlusCell.nibName, forCellWithReuseIdentifier: PlusCell.identifier)
    }

    func loadOrders(){
        StorageManager.sharedInstance.getDefaultRealm { (realm) in
            self.datasourceOrders = realm.objects(Order.self)
            self.collectionViewOrder.reloadData()
        }
    }

}

//MARK: - CollectionView
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let datasourceOrders = self.datasourceOrders else {
            return 1
        }
        return datasourceOrders.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let datasourceOrders = self.datasourceOrders else {
            let cellPlus = collectionView.dequeueReusableCell(withReuseIdentifier: PlusCell.identifier, for: indexPath) as! PlusCell
            return cellPlus
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderBigCell.identifier, for: indexPath) as! OrderBigCell
        cell.labelTitle.text = datasourceOrders[indexPath.item].date.toString(format: "dd.MM.yy")
        cell.imageView.image = UIImage(named: "list")
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let _ = self.datasourceOrders else {
            performSegue(withIdentifier: "segueNewOrder", sender: nil)
            return
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return PlusCell.size
    }

}
