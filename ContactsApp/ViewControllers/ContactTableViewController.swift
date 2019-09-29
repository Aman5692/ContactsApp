//
//  ContactTableViewController.swift
//  ContactsApp
//
//  Created by Aman Agarwal on 29/09/19.
//  Copyright © 2019 Aman Agarwal. All rights reserved.
//

import UIKit

class ContactTableViewController: UITableViewController {
    
    var dataSourceArray : Array = Array<ContactListModel>.init()
    let spinnerVC = SpinnerViewController()
    
    @IBAction func createNewContact(_ sender: UIBarButtonItem) {
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customiseTableView()
        
        self.createAndStartSpinner()
        
        NetworkUtility.getContactsList(handler: { (responseList, error) in
            self.removeSpinner()
            guard let data = responseList else {
                print("Unable to fetch contact list")
                return
            }
            self.dataSourceArray = data
            self.reloadTableView(sync: true)
        })
    }
    
    // MARK: - Utility Methods
    
    func customiseTableView() {
        self.tableView.rowHeight = CGFloat(kContactListCellHeight)
        self.tableView.separatorColor = UIColor(hexString: "#F0F0F0")
        
    }
    
    func reloadTableView(sync : Bool) {
        let block : CompletionBlock = {
            self.tableView.reloadData()
        }
        performBlockOnMainThread(sync: sync, block: block)
    }
    
    func createAndStartSpinner() {
        // add the spinner view controller
        addChild(spinnerVC)
        spinnerVC.view.frame = view.frame
        view.addSubview(spinnerVC.view)
        spinnerVC.didMove(toParent: self)
    }
    
    func removeSpinner() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            // then remove the spinner view controller
            self.spinnerVC.willMove(toParent: nil)
            self.spinnerVC.view.removeFromSuperview()
            self.spinnerVC.removeFromParent()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSourceArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactListCell", for: indexPath)
        guard let customCell : ContactListTableViewCell = cell as? ContactListTableViewCell else {
            return cell
        }
        let model : ContactListModel = self.dataSourceArray[indexPath.row]
        ImageCacheUtility.downloadImage(url: model.profilePic, handler: { (image, error) in
            if let error = error {
                print("Unable to fetch profile pic for URL : with error",model.profilePic,error)
            }
            else if let image = image {
                let block : CompletionBlock = {
                    customCell.imageView?.image = image
                }
                performBlockOnMainThread(sync: true, block: block)
            }
        })
        customCell.acountNameLabel.text = model.firstName + " " + model.lastName
        customCell.favouriteImageView.isHidden = !model.favorite
        // Configure the cell...

        return customCell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
