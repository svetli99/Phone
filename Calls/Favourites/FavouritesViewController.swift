import UIKit

class FavouritesViewController: UITableViewController {
    let store = ContactStore.shared
    
    var favourites: [(Contact,String)]!
    
    var prevContact: Contact?
    var prevIndex = 0
    
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
        let type = favourites[indexPath.row].1
        let cell = tableView.dequeueReusableCell(withIdentifier: type) as! FavouriteCell
        
        cell.nameLabel.text = (contact.firstName ?? "") + (contact.lastName ?? "")
        if let first = contact.firstName?.first {
            cell.IDLabel.text = String(first)
        } else if let first = contact.lastName?.first {
            cell.IDLabel.text = String(first)
        }
        if let prevContact = prevContact, prevContact != contact {
            prevIndex = 0
        }
        if let favIndex = contact.noAttributesItems.phone?[prevIndex...].firstIndex(where: {$0.isFavourite!}) {
            cell.type.text = contact.noAttributesItems.phone?[favIndex].type
            prevIndex = favIndex + 1
        }
        cell.favouriteType = type
        prevContact = contact
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //favourites[indexPath.row].isFavourite.toggle()
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
                let callName = (favourites[row].0.firstName ?? "")
                callViewController.name = callName
            }
        case "Info":
            if let indexPath = sender as? IndexPath {
                let contactInfoViewController = segue.destination as! ContactInfoViewController
                let conatct = favourites[indexPath.row].0
                contactInfoViewController.contact = conatct
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}
