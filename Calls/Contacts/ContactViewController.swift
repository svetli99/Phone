//
//  ViewController.swift
//  Contacts
//
//  Created by Svetlio on 9.04.21.
//

import UIKit

class ContactViewController: UITableViewController, UISearchResultsUpdating {
    var contactStore = ContactStore.shared
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 65
        tableView.rowHeight = 40
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController = UISearchController()
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return contactStore.allContacts.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return contactStore.getSectoinTittle(section: section)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contactStore.getNumberOfRows(section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->         UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        let contact = contactStore.getContact(section: indexPath.section, row: indexPath.row)
        cell.name.text = contact.name
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchController.textInputContextIdentifier
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CallViewController" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let callViewController = segue.destination as! CallViewController
                let conatct = contactStore.getContact(section: indexPath.section, row: indexPath.row)
                callViewController.name = conatct.name
            }
            
        } else {
            preconditionFailure("Unexpected segue identifier.")
        }
    }

}

