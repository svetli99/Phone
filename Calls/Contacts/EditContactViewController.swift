import UIKit

class EditContactViewController: UITableViewController {
    let store = ContactStore.shared
    // TO DO: Notes
    var contact: Contact! {
        didSet {
            if isNew {
                labelTitles.removeLast()
                cellIdentifires.removeLast()
            } else {
                addNames()
                addRemoveCells(contact.noAttributesItems.phone, numberSection)
                addRemoveCells(contact.noAttributesItems.email, emailSection)
                addRemoveCells(contact.noAttributesItems.url, urlSection)
                addRemoveCells(contact.noAttributesItems.address, addressSection)
                addRemoveCells(contact.noAttributesItems.birthday, birthdaySection)
                addRemoveCells(contact.noAttributesItems.date, dateSection)
                addRemoveCells(contact.noAttributesItems.relatedName, relatedNameSection)
                addRemoveCells(contact.noAttributesItems.socialProfile, socialProfileSection)
                addRemoveCells(contact.noAttributesItems.instantMessage, messageSection)
            }
        }
    }
    
    var labelTitles: [[[String]]] = [
        [["First name",""],["Last name",""],["Company",""]],
        [["add phone", "Phone"]],
        [["add email", "Email"]],
        [["Ringtone","Default"]],
        [["Text Tone","Default"]],
        [["add url", "URL"]],
        [["add address", "Address"]],
        [["add birthday", "Birthday"]],
        [["add date", "Date"]],
        [["add related name", "Related Name"]],
        [["add social profile", "Social Profile"]],
        [["add instant message", "Message"]],
        [[""]],
        [["add field"]],
        [["link contacts..."]],
        [["Delete contact"]]
    ]
    
    var cellIdentifires = [
        ["textField", "textField", "textField"],
        ["Add"],
        ["Add"],
        ["Tones"],
        ["Tones"],
        ["Add"],
        ["Add"],
        ["Add"],
        ["Add"],
        ["Add"],
        ["Add"],
        ["Add"],
        ["Notes"],
        ["Add field"],
        ["Add"],
        ["Delete"]
    ]
    
    let addressPlaceholders = ["Street","Street","PostCode","City","Country"]
    
    var maxX = CGFloat(0)
    
    var isNew = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.setEditing(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBar = presentingViewController as? UITabBarController,
           let navVC = tabBar.selectedViewController as? UINavigationController,
           let contactsVC = navVC.topViewController as? ContactsViewController {
            DispatchQueue.main.async {
                contactsVC.tableView.reloadData()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        cellIdentifires.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellIdentifires[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifires[indexPath.section][indexPath.row], for: indexPath)
        switch cell {
        case let custom as TextFieldCell:
            custom.textField.placeholder = labelTitles[indexPath.section][indexPath.row].first!
            custom.textField.text = labelTitles[indexPath.section][indexPath.row].last!
            custom.textField.indexPath = indexPath
            custom.textField.tag = 1
            custom.textField.addTarget(self, action: #selector(valueChanged(_:)), for: .editingChanged)
            cell = custom
        case let custom as ButtonCell:
            custom.label.text = labelTitles[indexPath.section][indexPath.row][0]
            cell = custom
        case let custom as AddCell:
            custom.label.text = labelTitles[indexPath.section][indexPath.row][0]
            cell = custom
        case let custom as RemoveCell:
            if let type = custom.typeButton.currentTitle {
                labelTitles[indexPath.section][indexPath.row][0] = type
            } else {
                custom.typeButton.setTitle(labelTitles[indexPath.section][indexPath.row][0], for: .normal)
            }
//            if indexPath.row == 0 {
//                maxX = custom.leadingChevronConstraint.secondItem!.frame!.maxX
//            } else {
//                custom.contentView.layoutIfNeeded()
//                moveArrow(indexPath, custom)
//            }
            custom.textField.placeholder = labelTitles[indexPath.section][indexPath.row][1]
            if labelTitles[indexPath.section][indexPath.row][2] != ""{
                custom.textField.text = labelTitles[indexPath.section][indexPath.row][2]
            } else {
                custom.textField.becomeFirstResponder()
            }
            custom.textField.addTarget(self, action: #selector(valueChanged(_:)), for: .editingChanged)
            custom.textField.indexPath = indexPath
            custom.textField.tag = 2
            cell = custom
        case let custom as TonesCell:
            custom.label.text = labelTitles[indexPath.section][indexPath.row][0]
            custom.typeLabel.text = labelTitles[indexPath.section][indexPath.row][1]
            cell = custom
        case let custom as NotesCell:
            custom.textField.text = labelTitles[indexPath.section][indexPath.row].first!
            custom.textField.indexPath = indexPath
            custom.textField.tag = 0
            custom.textField.addTarget(self, action: #selector(valueChanged(_:)), for: .editingChanged)
            cell = custom
        case let custom as AddressCell:
            if let type = custom.typeButton.currentTitle {
                labelTitles[indexPath.section][indexPath.row][0] = type
            } else {
                custom.typeButton.setTitle(labelTitles[indexPath.section][indexPath.row][0], for: .normal)
            }
//            if indexPath.row == 0 {
//                maxX = custom.leadingChevronConstraint.secondItem!.frame!.maxX
//            } else {
//                custom.contentView.layoutIfNeeded()
//                moveArrow(indexPath, custom)
//            }
            custom.street1.text = labelTitles[indexPath.section][indexPath.row][1]
            custom.street1.placeholder = labelTitles[indexPath.section][indexPath.row][2]
            custom.street2.text = labelTitles[indexPath.section][indexPath.row][3]
            custom.street2.placeholder = labelTitles[indexPath.section][indexPath.row][4]
            custom.postCode.text = labelTitles[indexPath.section][indexPath.row][5]
            custom.postCode.placeholder = labelTitles[indexPath.section][indexPath.row][6]
            custom.city.text = labelTitles[indexPath.section][indexPath.row][7]
            custom.city.placeholder = labelTitles[indexPath.section][indexPath.row][8]
            custom.country.text = labelTitles[indexPath.section][indexPath.row][9]
            custom.country.placeholder = labelTitles[indexPath.section][indexPath.row][10]
            

            
            custom.street1.addTarget(self, action: #selector(valueChanged(_:)), for: .editingChanged)
            custom.street1.indexPath = indexPath
            custom.street1.tag = 1
            custom.street2.addTarget(self, action: #selector(valueChanged(_:)), for: .editingChanged)
            custom.street2.indexPath = indexPath
            custom.street2.tag = 3
            custom.postCode.addTarget(self, action: #selector(valueChanged(_:)), for: .editingChanged)
            custom.postCode.indexPath = indexPath
            custom.postCode.tag = 5
            custom.city.addTarget(self, action: #selector(valueChanged(_:)), for: .editingChanged)
            custom.city.indexPath = indexPath
            custom.city.tag = 7
            custom.country.addTarget(self, action: #selector(valueChanged(_:)), for: .editingChanged)
            custom.country.indexPath = indexPath
            custom.country.tag = 9
            cell = custom
        default:
            break
        }

        return cell
    }
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
////        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifires[indexPath.section][indexPath.row], for: indexPath) as? RemoveCell {
////            if indexPath.row == 0 {
////                maxX = cell.leadingChevronConstraint.secondItem!.frame!.maxX
////            } else {
////                cell.contentView.layoutIfNeeded()
////                moveArrow(indexPath, cell)
////            }
////        }
//
//
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let custom = cell as? ButtonCell {
            if custom.label.text == "Delete contact" {
                let alertController = UIAlertController(title: nil,message: nil,preferredStyle: .actionSheet)
                
                alertController.modalPresentationStyle = .popover
    
                let delete = UIAlertAction(title: "Delete Contact", style: .destructive) { _ in
                    self.store.deleteContact(contact: self.contact)
                    self.dismiss(animated: true)
                    (self.presentingViewController as? UINavigationController)?.popToRootViewController(animated: true)
                }
                alertController.addAction(delete)

                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancel)
                
                present(alertController, animated: true, completion: nil)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cellIdentifires[indexPath.section].remove(at: indexPath.row)
            labelTitles[indexPath.section].remove(at: indexPath.row)
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
        } else if editingStyle == .insert {
            let cell = tableView.cellForRow(at: indexPath) as! AddCell
            let usedTags = labelTitles[indexPath.section].map{$0[0]}
            let typeName = store.tags.first(where: { !usedTags.contains($0) }) ?? store.tags.first!
            var labels = [String]()
            switch cell.label.text {
            case "add address":
                cellIdentifires[indexPath.section].insert("Address", at: indexPath.row)
                labels = [typeName] + addressData(["","","","",""])
            case "add phone", "add email":
                cellIdentifires[indexPath.section].insert("Remove", at: indexPath.row)
                let placeholder = labelTitles[indexPath.section][indexPath.row][1]
                labels = [typeName, placeholder,"","0"]
            default:
                cellIdentifires[indexPath.section].insert("Remove", at: indexPath.row)
                let placeholder = labelTitles[indexPath.section][indexPath.row][1]
                labels = [typeName, placeholder,""]
            }
            labelTitles[indexPath.section].insert(labels, at: indexPath.row)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let totalRow = tableView.numberOfRows(inSection: indexPath.section)
        return indexPath.row == totalRow - 1 ? .insert : .delete
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
           switch indexPath.section {
           case 0, 3, 4, 12, 13, 15:
               return false
           default:
               return true
           }
       }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let title = "Are you shure you want to discard " + (isNew ? "this new contact?" : "your changes?")
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        alertController.modalPresentationStyle = .popover
        alertController.popoverPresentationController?.barButtonItem = sender
        
        let discardChanges = UIAlertAction(title: "Discard Changes", style: .destructive) { _ in
            self.dismiss(animated: true)
        }
        alertController.addAction(discardChanges)

        let keepEditing = UIAlertAction(title: "Keep Editing", style: .cancel, handler: nil)
        alertController.addAction(keepEditing)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        contact.firstName = getName(labelTitles[nameSection][firstNameIndex])
        contact.lastName = getName(labelTitles[nameSection][lastNameIndex])
        
        guard contact.firstName != nil || contact.lastName != nil else {
            return
        }
        
        contact.company = getName(labelTitles[nameSection][companyIndex])
        contact.notes = getName(labelTitles[notesSection].first!)
        
        for i in labelTitles[1...].indices where labelTitles[i].count > 1 {
            switch i {
            case numberSection:
                addToAtributes(&contact.noAttributesItems.phone, labelTitles[i])
            case emailSection:
                addToAtributes(&contact.noAttributesItems.email, labelTitles[i])
            case urlSection:
                addToAtributes(&contact.noAttributesItems.url, labelTitles[i])
            case addressSection:
                addToAddressAtribute(&contact.noAttributesItems.address, labelTitles[i])
            case dateSection:
                addToAtributes(&contact.noAttributesItems.date, labelTitles[i])
            case birthdaySection:
                addToAtributes(&contact.noAttributesItems.birthday, labelTitles[i])
            case relatedNameSection:
                addToAtributes(&contact.noAttributesItems.relatedName, labelTitles[i])
            case messageSection:
                addToAtributes(&contact.noAttributesItems.instantMessage, labelTitles[i])
            case socialProfileSection:
                addToAtributes(&contact.noAttributesItems.socialProfile, labelTitles[i])
            default:
                break
            }
        }
        
        store.parseToJSON(contact)
        if isNew {
            store.addNewContact(contact: contact)
        }
        dismiss(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let button = sender as? UIButton {
            if segue.identifier == "Tags" {
                let navVC = segue.destination as! UINavigationController
                let tagsViewController = navVC.topViewController as! TagsViewController
                tagsViewController.selectedButton = button
            } else {
                preconditionFailure("Unexpected segue identifier.")
            }
        }
    }
    
    private func addNames() {
        labelTitles[nameSection][firstNameIndex][1] = contact.firstName ?? ""
        labelTitles[nameSection][lastNameIndex][1] = contact.lastName ?? ""
        labelTitles[nameSection][companyIndex][1] = contact.company ?? ""
        labelTitles[notesSection][0][0] = contact.notes ?? ""
    }
    
    private func addRemoveCells(_ array: [Any]?,_ section: Int) {
        guard let arr = array else { return }
        var index = labelTitles[section].count - 1
        for (i, info) in arr.enumerated() {
            switch info {
            case let info as ContactInfoItem:
                let placeholder = labelTitles[section][i][1]
                var labels = [info.type,placeholder, info.value]
                if let isFavourite = info.isFavourite {
                    let favourite = isFavourite ? "1" : "0"
                    labels.append(favourite)
                }
                labelTitles[section].insert(labels, at: index)
                cellIdentifires[section].insert("Remove", at: index)
            case let info as ContactAddress:
                labelTitles[section].insert([info.type,info.street1,addressPlaceholders[0],info.street2,addressPlaceholders[1],info.postCode,addressPlaceholders[2],info.city,addressPlaceholders[3],info.country,addressPlaceholders[4]], at: index)
                cellIdentifires[section].insert("Address", at: index)
            default:
                break
            }
            index += 1
        }
    }
    
    private func addressData(_ parts: [String]) -> [String] {
        zip(parts, addressPlaceholders).flatMap { [$0.0,$0.1] }
    }
    
    private func moveArrow(_ indexPath: IndexPath,_ custom: RemoveCell) {
        let customFirstItemMaxX = custom.leadingChevronConstraint.secondItem!.frame!.maxX
        if customFirstItemMaxX < maxX {
            let dif = maxX - customFirstItemMaxX
            custom.leadingChevronConstraint.constant += dif
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        maxX = max(maxX, customFirstItemMaxX)
    }
    
    private func getName(_ arr: [String]) -> String? {
        if arr.last != "" {
            return arr.last
        }
        return nil
    }
    
    private func isAddressForAdding(_ arr: [String]) -> Bool {
        for i in arr[1...].indices where i % 2 == 1 {
            if arr[i] != "" {
                return true
            }
        }
        return false
    }
    
    private func addToAtributes(_ attribute: inout [ContactInfoItem]?,_ arr: [[String]]) {
        
        var info = [ContactInfoItem]()
        for parts in arr {
            switch parts.count {
            case 3:
                if parts.last! != "" {
                    let contactInfo = ContactInfoItem(type: parts.first!, value: parts.last!)
                    info.append(contactInfo)
                }
            case 4:
                if parts[2] != "" {
                    let contactInfo = ContactInfoItem(type: parts.first!, value: parts[2], isFavourite: parts.last! == "1")
                    info.append(contactInfo)
                }
            default :
                break
            }
        }
        if !info.isEmpty {
            attribute = info
        }
    }
    
    private func addToAddressAtribute(_ address: inout [ContactAddress]?,_ arr: [[String]]) {
        var info = [ContactAddress]()
        for parts in arr.dropLast() {
            if isAddressForAdding(parts) {
                let values: [String] = parts[1...].indices.compactMap {
                    if $0 % 2 == 1 {
                        return parts[$0]
                    }
                    return nil
                }
                let contactInfo = ContactAddress(type: parts.first!, values: values)
                info.append(contactInfo)
            }
        }
        if !info.isEmpty {
            address = info
        }
    }
    
    @objc func valueChanged(_ textField: MyTextField) {
        labelTitles[textField.indexPath.section][textField.indexPath.row][textField.tag] = textField.text ?? ""
    }
}
