//
//  NewOrderViewController.swift
//  warehouse
//
//  Created by Alessandro Perna on 03/11/2020.
//

import UIKit
import RealmSwift

class NewOrderViewController: UIViewController {

    @IBOutlet weak var labelTitleDepartments:UILabel!
    @IBOutlet weak var labelTitleCategories:UILabel!
    @IBOutlet weak var labelTitleSuppliers:UILabel!
    @IBOutlet weak var collectionViewDepartment:UICollectionView!
    @IBOutlet weak var collectionViewCategories:UICollectionView!
    @IBOutlet weak var collectionViewSuppliers:UICollectionView!

    @IBOutlet weak var stackViewDepartment:UIStackView!
    @IBOutlet weak var stackViewCategories:UIStackView!
    @IBOutlet weak var stackViewSuppliers:UIStackView!

    var departmentIndexPath: IndexPath?
    var categoryIndexPath: IndexPath?
    var supplierIndexPath: IndexPath?


    var datasourceDepartments:Results<Department>?{
        didSet{
            if let datasourceDepartments = datasourceDepartments {
                notificationToken = datasourceDepartments.observe(collectionViewDepartment.applayChanges)
            }
        }
    }
    var datasourceCategories:Results<Category>?{
        didSet{
            if let datasourceCategories = datasourceCategories {
                notificationToken = datasourceCategories.observe(collectionViewCategories.applayChanges)
            }
        }
    }

    var datasourceSuppliers:Results<Supplier>?{
        didSet{
            if let datasourceSuppliers = datasourceSuppliers {
                notificationToken = datasourceSuppliers.observe(collectionViewSuppliers.applayChanges)
            }
        }
    }

    private var category:Category?
    private var supplier:Supplier?

    var notificationToken: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        settings()
        loadDepartments()
        isModalInPresentation = false
        self.navigationController?.presentationController?.delegate = self

    }



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? AddSuppliersViewController{
            vc.category = self.category
        }
        if let vc = segue.destination as? ItemForOrderViewController{
            vc.category = self.category
            vc.supplier = self.supplier
        }


    }


    //MARK: - Actions
    @IBAction func closeButtonPressed(button: UIBarButtonItem){
        self.navigationController?.dismiss(animated: true, completion: nil)
        //cancelRealmSession()
    }
    @IBAction func nextButtonPressed(button: UIBarButtonItem){

    }


    //MARK: - Methods
    func settings(){

        labelTitleDepartments.initialize(textValue: "Reparti",
                                         font: UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold),
                                         color: UIColor.darkGray,
                                         align: .left)
        labelTitleCategories.initialize(textValue: "Categorie",
                                         font: UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold),
                                         color: UIColor.darkGray,
                                         align: .left)
        labelTitleSuppliers.initialize(textValue: "Fornitori",
                                         font: UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold),
                                         color: UIColor.darkGray,
                                         align: .left)


        collectionViewSettings()
    }

    func collectionViewSettings(){

        collectionViewDepartment.register(PlusCell.nibName, forCellWithReuseIdentifier: PlusCell.identifier)
        collectionViewDepartment.register(OrderBigCell.nibName, forCellWithReuseIdentifier: OrderBigCell.identifier)
        collectionViewCategories.register(PlusCell.nibName, forCellWithReuseIdentifier: PlusCell.identifier)
        collectionViewCategories.register(OrderBigCell.nibName, forCellWithReuseIdentifier: OrderBigCell.identifier)
        collectionViewSuppliers.register(PlusCell.nibName, forCellWithReuseIdentifier: PlusCell.identifier)
        collectionViewSuppliers.register(OrderBigCell.nibName, forCellWithReuseIdentifier: OrderBigCell.identifier)
    }

    func loadDepartments(){
        StorageManager.sharedInstance.getDefaultRealm { (realm) in
            self.datasourceDepartments = realm.objects(Department.self)
            self.stackViewCategories.isHidden = true
            self.stackViewSuppliers.isHidden = true
            self.collectionViewDepartment.reloadData()
        }
    }
    func loadCategories(departmentId:String){
        StorageManager.sharedInstance.getDefaultRealm { (realm) in
            self.datasourceCategories = realm.objects(Category.self).filter("ANY department.id = %@", departmentId)
            self.stackViewCategories.isHidden = false
            self.stackViewSuppliers.isHidden = true
            self.collectionViewCategories.reloadData()
        }
    }
    func loadSuppliers(categoryId:String){
        StorageManager.sharedInstance.getDefaultRealm { (realm) in
            self.datasourceSuppliers = realm.objects(Supplier.self).filter("ANY categories.id = %@", categoryId)
            self.stackViewSuppliers.isHidden = false
            self.collectionViewSuppliers.reloadData()
        }
    }


}

//MARK: - CollectionView
extension NewOrderViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if collectionView == collectionViewDepartment{

            guard let datasourceDepartments = self.datasourceDepartments else {
                return 1
            }
            return datasourceDepartments.count + 1

        }else if collectionView == collectionViewCategories{

            guard let datasourceCategories = self.datasourceCategories else {
                return 1
            }
            return datasourceCategories.count + 1

        }else{

            guard let datasourceSuppliers = self.datasourceSuppliers else {
                return 1
            }
            return datasourceSuppliers.count + 1

        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == collectionViewDepartment{

            guard let datasourceDepartments = self.datasourceDepartments else {
                let cellPlus = collectionView.dequeueReusableCell(withReuseIdentifier: PlusCell.identifier, for: indexPath) as! PlusCell
                return cellPlus
            }

            if indexPath.item < datasourceDepartments.count {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderBigCell.identifier, for: indexPath) as! OrderBigCell
                cell.labelTitle.text = datasourceDepartments[indexPath.item].name
                cell.imageView.image = UIImage(named: "flyers")
                return cell
            }else{
                let cellPlus = collectionView.dequeueReusableCell(withReuseIdentifier: PlusCell.identifier, for: indexPath) as! PlusCell
                return cellPlus
            }

        }else if collectionView == collectionViewCategories{

            guard let datasourceCategories = self.datasourceCategories else {
                let cellPlus = collectionView.dequeueReusableCell(withReuseIdentifier: PlusCell.identifier, for: indexPath) as! PlusCell
                return cellPlus
            }

            if indexPath.item < datasourceCategories.count {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderBigCell.identifier, for: indexPath) as! OrderBigCell
                cell.labelTitle.text = datasourceCategories[indexPath.item].name
                cell.imageView.image = UIImage(named: "category")
                return cell
            }else{
                let cellPlus = collectionView.dequeueReusableCell(withReuseIdentifier: PlusCell.identifier, for: indexPath) as! PlusCell
                return cellPlus
            }

        }else{

            guard let datasourceSuppliers = self.datasourceSuppliers else {
                let cellPlus = collectionView.dequeueReusableCell(withReuseIdentifier: PlusCell.identifier, for: indexPath) as! PlusCell
                return cellPlus
            }

            if indexPath.item < datasourceSuppliers.count {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderBigCell.identifier, for: indexPath) as! OrderBigCell
                cell.labelTitle.text = datasourceSuppliers[indexPath.item].businessName
                cell.imageView.image = UIImage(named: "distribution")
                return cell
            }else{
                let cellPlus = collectionView.dequeueReusableCell(withReuseIdentifier: PlusCell.identifier, for: indexPath) as! PlusCell
                return cellPlus
            }

        }


    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if collectionView == collectionViewDepartment{

            guard let datasourceDepartments = self.datasourceDepartments else {
                performSegue(withIdentifier: "segueNewDepartment", sender: nil)
                return
            }

            if let _ = collectionView.cellForItem(at: indexPath) as? OrderBigCell{
                let departmentId = datasourceDepartments[indexPath.item].id
                loadCategories(departmentId: departmentId)
            }


            if let _ = collectionView.cellForItem(at: indexPath) as? PlusCell{
                performSegue(withIdentifier: "segueNewDepartment", sender: nil)
            }

        }else if collectionView == collectionViewCategories{
            guard let datasourceCategories = self.datasourceCategories else {
                performSegue(withIdentifier: "segueNewCategory", sender: nil)
                return
            }

            if let _ = collectionView.cellForItem(at: indexPath) as? OrderBigCell{
                self.category = datasourceCategories[indexPath.item]
                let categoryId = datasourceCategories[indexPath.item].id
                loadSuppliers(categoryId: categoryId)
            }

            if let _ = collectionView.cellForItem(at: indexPath) as? PlusCell{
                performSegue(withIdentifier: "segueNewCategory", sender: nil)
            }

        }else{

            guard let datasourceSuppliers = self.datasourceSuppliers else {
                performSegue(withIdentifier: "segueNewSupplier", sender: nil)
                return
            }

            if let _ = collectionView.cellForItem(at: indexPath) as? OrderBigCell{
                self.supplier = datasourceSuppliers[indexPath.item]
            }

            if let _ = collectionView.cellForItem(at: indexPath) as? PlusCell{
                performSegue(withIdentifier: "segueNewSupplier", sender: nil)
            }
        }

    }



    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == collectionViewDepartment{

            guard let _ = self.datasourceDepartments else {
                return PlusCell.size
            }
            return OrderBigCell.size

        }else if collectionView == collectionViewCategories{

            guard let _ = self.datasourceCategories else {
                return PlusCell.size
            }
            return OrderBigCell.size

        }else{

            guard let _ = self.datasourceSuppliers else {
                return PlusCell.size
            }
            return OrderBigCell.size

        }

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }


}

extension NewOrderViewController: UIAdaptivePresentationControllerDelegate{
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print(#function)
    }
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        print(#function)
        return true
    }

    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        print(#function)
    }

}
