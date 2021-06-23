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
    var isFromFavourite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 40
        navigationController?.navigationBar.prefersLargeTitles = true
        if isFromFavourite {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelFavourite))
            navigationItem.prompt = "Choose a contact to add to Favourites"
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContact))
        }
        
        searchController = UISearchController()
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBar = presentingViewController as? UITabBarController,
           let navVC = tabBar.selectedViewController as? UINavigationController,
           let favouritesVC = navVC.topViewController as? FavouritesViewController {
            favouritesVC.viewWillAppear(true)
        }
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
        cell.name.text = (contact.firstName ?? "") + (contact.lastName == nil ? "" : " \(contact.lastName!)")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFromFavourite {
            let alertStoryboard = UIStoryboard(name: "AlertStoryboard", bundle: nil)
            let alertController = alertStoryboard.instantiateViewController(withIdentifier: "MyAlert") as! AlertViewController
            alertController.contact = contactStore.getContact(section: indexPath.section, row: indexPath.row)
            alertController.modalPresentationStyle = .overFullScreen
            present(alertController, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "ContactInfo", sender: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return contactStore.groupedContacts.firstIndex(where: { String($0.0) == title }) ?? 26
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return contactStore.sectionTitles
        //return contactStore.groupedContacts.map { String($0.0) }
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
    
    @objc func addContact() {
        performSegue(withIdentifier: "NewContact", sender: nil)
    }
    
    @objc func cancelFavourite() {
        dismiss(animated: true)
    }

}
