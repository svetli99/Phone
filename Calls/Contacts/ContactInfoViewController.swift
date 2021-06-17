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
    
    var call: Call? {
        didSet {
            if call != nil {
                recentDif = 1
            }
        }
    }
    
    var recentDif = 0
    
    let dateFormatterName: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
    let dateFormatterHours: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    let dateFormatterDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "dd.MM.yy"
        return formatter
    }()
    
    var notes: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        labelTitles = fixedLabels
        cellIdentifires = fixedIdentifires
        if call != nil {
            labelTitles.insert([[""]], at: 0)
            cellIdentifires.insert(["Call"], at: 0)
        }
        
        name = (contact.firstName ?? "") + " " + (contact.lastName ?? "")
        notes = contact.notes
        
        var section = 0 + recentDif
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
        case let custom as CallInfoCell:
            configureLastCallCell(call!.date!.last!, custom)
            call?.date?.forEach { date in
                let time = dateFormatterHours.string(from: date)
                let type = (call!.isMissed ? "Missed " : "Outgoing ") + "Call"
                custom.addCall(time: time, type: type)
            }
//            custom.type.text = (call!.isMissed ? "Missed " : "Outgoing ") + "Call"
//            custom.addCall()
            cell = custom
        case let custom as InfoCell:
            custom.type.text = labelTitles[indexPath.section][indexPath.row].first
            custom.number.text = labelTitles[indexPath.section][indexPath.row][1]
            if let call = call, custom.number.text == call.number {
                if call.isMissed {
                    custom.number.textColor = .red
                }
                custom.recent.isHidden = false
            } else {
                custom.isFavourite.isHidden = labelTitles[indexPath.section][indexPath.row].last! == "0"
            }
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
        if let cell = cell as? InfoCell, indexPath.section == 0 + recentDif {
            let callViewController = storyboard?.instantiateViewController(identifier: "Dial") as! CallViewController
            callViewController.name = name
            callViewController.type = cell.type.text
            callViewController.number = cell.number.text
            callViewController.modalPresentationStyle = .fullScreen
            present(callViewController, animated: true, completion: nil)
        } else if cell is ButtonCell, indexPath.row == 2 {
            let alertStoryboard = UIStoryboard(name: "AlertStoryboard", bundle: nil)
            let alertController = alertStoryboard.instantiateViewController(withIdentifier: "MyAlert") as! AlertViewController
            alertController.contact = contact
            alertController.modalPresentationStyle = .overFullScreen
            present(alertController, animated: true, completion: nil)
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
                let isFavourite = info.isFavourite == nil ? "0" : info.isFavourite! ? "1" : "0"
                labelTitles[section].insert([info.type,info.value,isFavourite], at: index)
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
    
    func configureLastCallCell(_ date: Date,_ cell: CallInfoCell) {
        let startOfToday = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        if startOfToday < date {
            cell.day.text = "Today"
        }else if startOfToday.advanced(by: -60 * 60 * 24) < date {
            cell.day.text = "Yesterday"
        }else if startOfToday.advanced(by: -60 * 60 * 24 * 6) < date {
            cell.day.text = dateFormatterName.string(from: date)
        } else {
            cell.day.text = dateFormatterDate.string(from: date)
        }
    }
}
