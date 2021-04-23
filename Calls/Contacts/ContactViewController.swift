//
//  ViewController.swift
//  Contacts
//
//  Created by Svetlio on 9.04.21.
//

import UIKit

class ContactViewController: UITableViewController, UISearchResultsUpdating {
    var contactStore: ContactStore!
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactStore = ContactStore()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
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

}

