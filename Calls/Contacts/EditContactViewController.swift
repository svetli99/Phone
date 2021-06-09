import UIKit

class EditContactViewController: UITableViewController {
    let store = ContactStore.shared
    // TO DO: Notes
    var contact: Contact! {
        didSet {
            
            addNames()
            addRemoveCells(contact.number, numberSection)
            addRemoveCells(contact.email, emailSection)
            addRemoveCells(contact.url, urlSection)
            addAddressCells(contact.address, addressSection)
            addRemoveCells(contact.birthday, birthdaySection)
            addRemoveCells(contact.date, dateSection)
            addRemoveCells(contact.relatedName, relatedNameSection)
            addRemoveCells(contact.socialProfile, socialProfileSection)
            addRemoveCells(contact.instantMessage, messageSection)
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
        [["",""]],
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
        case let custom as RemoveCell:
            if let type = custom.tagButton.currentTitle {
                labelTitles[indexPath.section][indexPath.row][0] = type
            } else {
                custom.tagButton.setTitle(labelTitles[indexPath.section][indexPath.row][0], for: .normal)
            }
//            if indexPath.row == 0 {
//                maxX = custom.leadingChevronConstraint.secondItem!.frame!.maxX
//            } else {
//                custom.contentView.layoutIfNeeded()
//                moveArrow(indexPath, custom)
//            }
            custom.textField.placeholder = labelTitles[indexPath.section][indexPath.row][1]
            if labelTitles[indexPath.section][indexPath.row].count == 3 {
                custom.textField.text = labelTitles[indexPath.section][indexPath.row][2]
            } else {
                custom.textField.becomeFirstResponder()
            }
            custom.textField.addTarget(self, action: #selector(valueChanged(_:)), for: .editingChanged)
            custom.textField.indexPath = indexPath
            custom.textField.tag = 2
            custom.setEditing(true, animated: true)
            custom.isEditing = true
            cell = custom
        case let custom as TonesCell:
            custom.label.text = labelTitles[indexPath.section][indexPath.row][0]
            custom.typeLabel.text = labelTitles[indexPath.section][indexPath.row][1]
            cell = custom
        case let custom as NotesCell:
            custom.textField.text = labelTitles[indexPath.section][indexPath.row].last!
            custom.textField.indexPath = indexPath
            custom.textField.tag = 1
            custom.textField.addTarget(self, action: #selector(valueChanged(_:)), for: .editingChanged)
            cell = custom
        case let custom as AddressCell:
            if let type = custom.tagButton.currentTitle {
                labelTitles[indexPath.section][indexPath.row][0] = type
            } else {
                custom.tagButton.setTitle(labelTitles[indexPath.section][indexPath.row][0], for: .normal)
            }
//            if indexPath.row == 0 {
//                maxX = custom.leadingChevronConstraint.secondItem!.frame!.maxX
//            } else {
//                custom.contentView.layoutIfNeeded()
//                moveArrow(indexPath, custom)
//            }
            custom.street1.placeholder = labelTitles[indexPath.section][indexPath.row][2]
            custom.street2.placeholder = labelTitles[indexPath.section][indexPath.row][4]
            custom.postCode.placeholder = labelTitles[indexPath.section][indexPath.row][6]
            custom.city.placeholder = labelTitles[indexPath.section][indexPath.row][8]
            custom.country.placeholder = labelTitles[indexPath.section][indexPath.row][10]
            
            if labelTitles[indexPath.section][indexPath.row].count == 11 {
                custom.street1.text = labelTitles[indexPath.section][indexPath.row][1]
                custom.street2.text = labelTitles[indexPath.section][indexPath.row][3]
                custom.postCode.text = labelTitles[indexPath.section][indexPath.row][5]
                custom.city.text = labelTitles[indexPath.section][indexPath.row][7]
                custom.country.text = labelTitles[indexPath.section][indexPath.row][9]
            } else {
                custom.street1.becomeFirstResponder()
            }
            
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
            
            custom.setEditing(true, animated: true)
            custom.isEditing = true
            cell = custom
        default:
            break
        }

        return cell
    }
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifires[indexPath.section][indexPath.row], for: indexPath) as? RemoveCell {
//            if indexPath.row == 0 {
//                maxX = cell.leadingChevronConstraint.secondItem!.frame!.maxX
//            } else {
//                cell.contentView.layoutIfNeeded()
//                moveArrow(indexPath, cell)
//            }
//        }
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let custom = cell as? ButtonCell {
            if custom.label.text == "add address" {
                cellIdentifires[indexPath.section].insert("Address", at: indexPath.row)
                let usedTags = labelTitles[indexPath.section].map{$0[0]}
                let tagName = store.tags.first(where: { !usedTags.contains($0) }) ?? store.tags.first!
                let labels = [tagName] + addressData(["","","","",""])
                labelTitles[indexPath.section].insert(labels, at: indexPath.row)
                tableView.insertRows(at: [indexPath], with: .automatic)
            } else {
                cellIdentifires[indexPath.section].insert("Remove", at: indexPath.row)
                let placeholder = labelTitles[indexPath.section][indexPath.row][1]
                let usedTags = labelTitles[indexPath.section].map{$0[0]}
                let tagName = store.tags.first(where: { !usedTags.contains($0) }) ?? store.tags.first!
                labelTitles[indexPath.section].insert([tagName, placeholder,""], at: indexPath.row)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cellIdentifires[indexPath.section].remove(at: indexPath.row)
            labelTitles[indexPath.section].remove(at: indexPath.row)
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let cell = tableView.cellForRow(at: indexPath)
        if cell is RemoveCell {
            return UITableViewCell.EditingStyle.delete
        }
        return UITableViewCell.EditingStyle.none
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Are you shure you want to discard your changes?",message: nil,preferredStyle: .actionSheet)
        
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
        var jsonDictionary = [String:[String:[String]]]()
        contact.firstName = getName(labelTitles[0][0])
        contact.lastName = getName(labelTitles[0][1])
        contact.company = getName(labelTitles[0][2])
        contact.notes = getName(labelTitles[12][0])
        for arr in labelTitles[1...] where arr.count > 1 {
            let type = arr.last![1]
            var dict = [String:[String]]()
            for parts in arr {
                if parts.count == 3,parts.last! != "" {
                    dict[parts[0]] = [parts.last!]
                } else if parts.count == 11, isAddressForAdding(parts) {
                    let address: [String] = parts[1...].indices.compactMap {
                        if $0 % 2 == 1 {
                            return parts[$0]
                        }
                        return nil
                    }
                    dict[parts[0]] = address
                }
            }
            
            jsonDictionary[type] = dict
        }
        contact.jsonDictionary = jsonDictionary
        store.parseToJSON(contact, jsonDictionary)
        store.setAllAttributes(contact)
        
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
        labelTitles[0][0][1] = contact.firstName ?? ""
        labelTitles[0][1][1] = contact.lastName ?? ""
        labelTitles[0][2][1] = contact.company ?? ""
        labelTitles[12][0][1] = contact.notes ?? ""
    }
    
    private func addRemoveCells(_ array: [(String,String)]?,_ section: Int) {
        guard let arr = array else { return }
        var index = labelTitles[section].count - 1
        for (i, pair) in arr.enumerated() {
            let placeholder = labelTitles[section][i][1]
            labelTitles[section].insert([pair.0,placeholder,pair.1], at: index)
            cellIdentifires[section].insert("Remove", at: index)
            index += 1
        }
    }
    
    private func addAddressCells(_ array: [(String,[String])]?,_ section: Int) {
        guard let arr = array else { return }
        var index = labelTitles[section].count - 1
        for parts in arr {
            let labels = [parts.0] + addressData(parts.1)
            labelTitles[section].insert(labels, at: index)
            cellIdentifires[section].insert("Address", at: index)
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
    
    @objc func valueChanged(_ textField: MyTextField) {
        labelTitles[textField.indexPath.section][textField.indexPath.row][textField.tag] = textField.text ?? ""
    }
}
