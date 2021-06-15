//
//  ViewController.swift
//  Contacts
//
//  Created by Svetlio on 9.04.21.
//

import UIKit

class ContactsViewController: UITableViewController, UISearchResultsUpdating {
    var contactStore = ContactStore.shared
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 40
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController = UISearchController()
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return contactStore.groupedContacts.count
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
        cell.name.text = (contact.firstName ?? "") + " " + (contact.lastName ?? "")
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        //searchController.textInputContextIdentifier
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "ContactInfo":
            if let indexPath = tableView.indexPathForSelectedRow {
                let contactInfoViewController = segue.destination as! ContactInfoViewController
                let conatct = contactStore.getContact(section: indexPath.section, row: indexPath.row)
                contactInfoViewController.contact = conatct
            }
        case "NewContact":
            let navVC = segue.destination as! UINavigationController
            let editContactViewController = navVC.topViewController as! EditContactViewController
            editContactViewController.isNew = true
            editContactViewController.contact = contactStore.createContact()
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
/*
     if segue.identifier == "CallViewController" {
         if let indexPath = tableView.indexPathForSelectedRow {
             let callViewController = segue.destination as! CallViewController
             let conatct = contactStore.getContact(section: indexPath.section, row: indexPath.row)
             callViewController.name = conatct.name
         }
         
     */
}

