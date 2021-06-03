import UIKit

class ContactInfoViewController: UITableViewController {
    var labelTitles = [
        [],
        [],
        [["Send Message"],["Share Contact"],["Add to Fovourites"]],
        [["Add to Emergency Contacts"]],
        [["Share My Location"]],
        [["Block this Caller"]]
    ]
    
    var cellIdentifires = [
        [],
        ["Notes"],
        ["Cell","Cell","Cell"],
        ["Cell"],
        ["Cell"],
        ["Block"]
    ]
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var IDLabel: UILabel!
    
    var contact: Contact! {
        didSet {
            name = contact.firstName! + " " + (contact.lastName ?? "")
            
            addNumberCells(contact.number, numSection)
        }
    }
    var name: String! {
        didSet {
            nameLabel.text = name
            IDLabel.text = String(name.first ?? "a").capitalized
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        //tableView.section = .blue
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        labelTitles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        labelTitles[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifires[indexPath.section][indexPath.row], for: indexPath)
        if let custom = cell as? NumberCell {
            custom.tagName.text = labelTitles[indexPath.section][indexPath.row][0]
            custom.number.text = labelTitles[indexPath.section][indexPath.row][1]
            cell = custom
        }else if let custom = cell as? ButtonCell  {
            custom.label.text = labelTitles[indexPath.section][indexPath.row][0]
            cell = custom
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditContact" {
            let navVC = segue.destination as! UINavigationController
            let editContactViewController = navVC.topViewController as! EditContactViewController
            editContactViewController.contact = contact
        } else {
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    private func addNumberCells(_ array: [(String, String)]?,_ section: Int) {
        guard let arr = array else { return }
        var index = labelTitles[section].count 
        arr.forEach { pair in
            labelTitles[section].insert([pair.0,pair.1], at: index)
            cellIdentifires[section].insert("Number", at: index)
            index += 1
        }
    }
    
}
