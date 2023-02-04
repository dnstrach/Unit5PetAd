//
//  CategoryTableViewController.swift
//  PetAd
//
//  Created by Dominique Strachan on 2/2/23.
//

import UIKit

class CategoryTableViewController: UITableViewController {

    var categories = ["Puppies", "Kittens"]

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let category = self.categories[indexPath.row]
        
        cell.textLabel?.text = category
        
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toAdTVC" {
            guard let destinationVC = segue.destination as? AdTableViewController,
                  let indexPath = tableView.indexPathForSelectedRow else { return }
            let category = self.categories[indexPath.row]
            
            //passing over category from category array containing puppies or kittens strings
            destinationVC.category = category
        }
    }

}
