import UIKit

class FavouritesViewController: UITableViewController {
    let store = ContactStore.shared
    
    var favourites: [(Contact,ContactInfoItem)]!
    
    @IBOutlet var addBarButon: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favourites = ContactStore.shared.favouriteContacts
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favourites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contact = favourites[indexPath.row].0
        let info = favourites[indexPath.row].1
        let cell = tableView.dequeueReusableCell(withIdentifier: info.favouriteType!) as! FavouriteCell
        
        cell.nameLabel.text = (contact.firstName ?? "") + (contact.lastName ?? "")
        if let first = contact.firstName?.first {
            cell.IDLabel.text = String(first)
        } else if let first = contact.lastName?.first {
            cell.IDLabel.text = String(first)
        }
        cell.type.text = info.type
        cell.favouriteType = info.favouriteType
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            favourites[indexPath.row].1.isFavourite!.toggle()
            favourites[indexPath.row].1.favouriteDate = nil
            favourites[indexPath.row].1.favouriteType = nil
            favourites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "Info", sender: indexPath)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        navigationItem.leftBarButtonItem =  isEditing ? nil : addBarButon
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "CallViewController" {
            if let cell = sender as? FavouriteCell {
                return cell.favouriteType == "Call"
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "CallViewController":
            if let row = tableView.indexPathForSelectedRow?.row {
                let callViewController = segue.destination as! CallViewController
                let contact = favourites[row].0
                let callName = (contact.firstName ?? contact.lastName!)
                callViewController.name = callName
                callViewController.type = favourites[row].1.type
                callViewController.number = favourites[row].1.value
            }
        case "Info":
            if let indexPath = sender as? IndexPath {
                let contactInfoViewController = segue.destination as! ContactInfoViewController
                let conatct = favourites[indexPath.row].0
                contactInfoViewController.contact = conatct
            }
        case "Contacts":
            let navController = segue.destination as! UINavigationController
            let contactsViewController = navController.topViewController as! ContactsViewController
            contactsViewController.isFromFavourite = true
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}
