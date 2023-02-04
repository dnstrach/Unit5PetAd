//
//  AdTableViewController.swift
//  PetAd
//
//  Created by Dominique Strachan on 2/2/23.
//

import UIKit

class AdTableViewController: UITableViewController {

    var category: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = category

        //fetch ads
        AdController.shared.fetchRecordAdsFromCloudKit(category: category)
        
        //Add observer
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: AdController.adsUpdatedToNotification, object: nil)
        
    }
    
    //MARK: - Outlets
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        createAdAlertController()
    }
    

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if  category == "Puppies" {
            return AdController.shared.puppyAds.count
        } else {
            return AdController.shared.kittenAds.count
        }
    
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adCell", for: indexPath)
        
        if category == "Puppies" {
            let puppyAd = AdController.shared.puppyAds[indexPath.row]
            cell.textLabel?.text = puppyAd.title
            cell.detailTextLabel?.text = "$\(puppyAd.price)"
        } else {
            let kittenAd = AdController.shared.kittenAds[indexPath.row]
            cell.textLabel?.text = kittenAd.title
            cell.detailTextLabel?.text = "\(kittenAd.price)"
        }
        
        return cell
    }
    
    //MARK: - Alert Controller
    func createAdAlertController() {
        var titleTextField: UITextField?
        var priceTextField: UITextField?
        
        let alertController = UIAlertController(title: "Create New Ad", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addTextField { (textField1) in
            textField1.placeholder = "Enter ad title"
            titleTextField = textField1
        }
        
        alertController.addTextField() { (textField2) in
            textField2.placeholder = "Enter Price"
            textField2.keyboardType = .numberPad
            priceTextField = textField2
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            //call the save to cloudKit function
            guard let title = titleTextField?.text,
                  title != "",
                  let price = priceTextField?.text,
                  let priceAsInt = Int(price)
            else { return }
            
            AdController.shared.saveRecordAdToCloudKit(title: title, price: priceAsInt, category: self.category)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

}
