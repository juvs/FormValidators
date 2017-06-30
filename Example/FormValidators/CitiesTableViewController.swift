//
//  CitiesTableViewController.swift
//  FormValidators
//
//  Created by Juvenal Guzman on 6/29/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class CitiesTableViewController: UITableViewController {

    var selectedCity: City?
    var data: [City] = [City(id: 1, name: "Mexico City"),
                        City(id: 2, name: "New York")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let city = data[indexPath.row]
        cell.textLabel?.text = city.name
        
        // Configure the cell...

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedCity = data[indexPath.row]
        performSegue(withIdentifier: "toSelectedCity", sender: self)
    }

}
