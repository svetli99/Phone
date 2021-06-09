import UIKit

class ContactInfoViewController: UITableViewController {
    let fixedLabels = [
        [[""]],
        [["Send Message"],["Share Contact"],["Add to Fovourites"]],
        [["Add to Emergency Contacts"]],
        [["Share My Location"]],
        [["Block this Caller"]]
    ]
    
    let fixedIdentifires = [
        ["Notes"],
        ["Cell","Cell","Cell"],
        ["Cell"],
        ["Cell"],
        ["Block"]
    ]
    
    var labelTitles = [[[String]]]()
    
    var cellIdentifires = [[String]]()
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var IDLabel: UILabel!
    
    var contact: Contact! 
    
    var name: String! {
        didSet {
            nameLabel.text = name
            IDLabel.text = String(name.first ?? "a").capitalized
        }
    }
    
    var notes: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        labelTitles = fixedLabels
        cellIdentifires = fixedIdentifires
        
        name = contact.firstName! + " " + (contact.lastName ?? "")
        notes = contact.notes
        
        var section = 0
        addNumberCells(contact.number, &section)
        addNumberCells(contact.email, &section)
        addNumberCells(contact.url, &section)
        addAddressCells(&section)
        addNumberCells(contact.birthday, &section)
        addNumberCells(contact.date, &section)
        addNumberCells(contact.relatedName, &section)
        addNumberCells(contact.socialProfile, &section)
        addNumberCells(contact.instantMessage, &section)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        labelTitles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellIdentifires[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifires[indexPath.section][indexPath.row], for: indexPath)
        switch cell {
        case let custom as NumberCell:
            custom.tagName.text = labelTitles[indexPath.section][indexPath.row].first
            custom.number.text = labelTitles[indexPath.section][indexPath.row][1]
            cell = custom
        case let custom as ButtonCell:
            custom.label.text = labelTitles[indexPath.section][indexPath.row][0]
            cell = custom
        case let custom as NotesCell:
            custom.textField.text = notes
        case let custom as AddressInfoCell:
            custom.tagName.text = labelTitles[indexPath.section][indexPath.row].first
            let texts = Array(labelTitles[indexPath.section][indexPath.row][1...])
            addLabels(custom, texts: texts)
            tableView.reloadRows(at: [indexPath], with: .none)
        default:
            break
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
    
    private func addNumberCells(_ array: [(String, String)]?,_ section: inout Int) {
        guard let arr = array else { return }
        var index = 0
        labelTitles.insert([], at: section)
        cellIdentifires.insert([], at: section)
        arr.forEach { pair in
            labelTitles[section].insert([pair.0,pair.1], at: index)
            cellIdentifires[section].insert("Number", at: index)
            index += 1
        }
        section += 1
    }
    
    private func addAddressCells(_ section: inout Int) {
        guard let arr = contact.address else { return }
        var index = 0
        labelTitles.insert([], at: section)
        cellIdentifires.insert([], at: section)
        arr.forEach { pair in
            labelTitles[section].insert([pair.0] + pair.1, at: index)
            cellIdentifires[section].insert("Address", at: index)
            index += 1
        }
        section += 1
    }
    
    private func addLabels(_ cell: AddressInfoCell, texts: [String]) {
        for (i, text) in texts.enumerated() {
            if text != "" {
                cell.labels[i].isHidden = false
                cell.labels[i].text = text
            } else {
                cell.labels[i].isHidden = true
            }
        }
    }
    
}
