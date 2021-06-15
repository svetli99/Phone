import UIKit

class ContactInfoViewController: UITableViewController {
    let store = ContactStore.shared
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
        
        name = (contact.firstName ?? "") + " " + (contact.lastName ?? "")
        notes = contact.notes
        
        var section = 0
        addInfoCells(contact.noAttributesItems.phone, &section)
        addInfoCells(contact.noAttributesItems.email, &section)
        addInfoCells(contact.noAttributesItems.url, &section)
        addInfoCells(contact.noAttributesItems.address, &section)
        addInfoCells(contact.noAttributesItems.birthday, &section)
        addInfoCells(contact.noAttributesItems.date, &section)
        addInfoCells(contact.noAttributesItems.relatedName, &section)
        addInfoCells(contact.noAttributesItems.socialProfile, &section)
        addInfoCells(contact.noAttributesItems.instantMessage, &section)
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
        case let custom as InfoCell:
            custom.type.text = labelTitles[indexPath.section][indexPath.row].first
            custom.number.text = labelTitles[indexPath.section][indexPath.row][1]
            cell = custom
        case let custom as ButtonCell:
            custom.label.text = labelTitles[indexPath.section][indexPath.row][0]
            cell = custom
        case let custom as NotesCell:
            custom.textField.text = notes
        case let custom as AddressInfoCell:
            custom.type.text = labelTitles[indexPath.section][indexPath.row].first
            let texts = Array(labelTitles[indexPath.section][indexPath.row][1...])
            addLabels(custom, texts: texts)
            tableView.reloadRows(at: [indexPath], with: .none)
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell is InfoCell, indexPath.section == 0 {
            let callViewController = storyboard?.instantiateViewController(identifier: "Dial") as! CallViewController
            callViewController.name = name
            callViewController.modalPresentationStyle = .fullScreen
            present(callViewController, animated: true, completion: nil)
        } else if cell is ButtonCell, indexPath.row == 2 {
            let alertStoryboard = UIStoryboard(name: "AlertStoryboard", bundle: nil)
            let alertController = alertStoryboard.instantiateViewController(withIdentifier: "MyAlert") as! AlertViewController
            alertController.contact = contact
            alertController.modalPresentationStyle = .overFullScreen
            present(alertController, animated: true, completion: nil)
            do {
                try store.persistentContainer.viewContext.save()
            } catch {
                print("Error save isFavourite: \(error)")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
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
    
    private func addInfoCells(_ arr: [Any]?,_ section: inout Int) {
        guard let arr = arr else { return }
        var index = 0
        labelTitles.insert([], at: section)
        cellIdentifires.insert([], at: section)
        arr.forEach { info in
            switch info {
            case let info as ContactInfoItem:
                labelTitles[section].insert([info.type,info.value], at: index)
                cellIdentifires[section].insert("Info", at: index)
            case let info as ContactAddress:
                labelTitles[section].insert([info.type,info.street1,info.street2,info.postCode,info.city,info.country], at: index)
                cellIdentifires[section].insert("Address", at: index)
            default:
                break
            }
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
