import UIKit

class EditContactViewController: UITableViewController {
    let store = ContactStore.shared
    
    var contact: Contact! {
        didSet {
            names[0] = contact.firstName
            names[1] = contact.lastName
            names[2] = contact.company
            
            addRemoveCells(contact.number, numberSection)
            addRemoveCells(contact.email, emailSection)
            addRemoveCells(contact.url, urlSection)
            addRemoveCells(contact.address, addressSection)
            addRemoveCells(contact.birthday, birthdaySection)
            addRemoveCells(contact.date, dateSection)
            addRemoveCells(contact.relatedName, relatedNameSection)
            addRemoveCells(contact.socialProfile, socialProfileSection)
            addRemoveCells(contact.instantMessage, messageSection)
            
        }
    }
    var names: [String?] = [nil,nil,nil]
    
    var labelTitles: [[[String]]] = [
        [["First name"],["Last name"],["Company"]],
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        labelTitles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        labelTitles[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifires[indexPath.section][indexPath.row], for: indexPath)
        switch cell {
        case let custom as TextFieldCell:
            custom.textField.placeholder = labelTitles[indexPath.section][indexPath.row][0]
            custom.textField.text = names[indexPath.row]
            cell = custom
        case let custom as ButtonCell:
            custom.label.text = labelTitles[indexPath.section][indexPath.row][0]
            cell = custom
        case let custom as RemoveCell:
            custom.tagButton.setTitle(labelTitles[indexPath.section][indexPath.row][0], for: .normal)
            custom.textField.placeholder = labelTitles[indexPath.section][indexPath.row][1]
            if labelTitles[indexPath.section][indexPath.row].count == 3 {
                custom.textField.text = labelTitles[indexPath.section][indexPath.row][2]
            }
            custom.setEditing(true, animated: true)
            custom.isEditing = true
            cell = custom
        case let custom as TonesCell:
            custom.label.text = labelTitles[indexPath.section][indexPath.row][0]
            custom.typeLabel.text = labelTitles[indexPath.section][indexPath.row][1]
            cell = custom
        default:
            break
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if cell is ButtonCell {
            cellIdentifires[indexPath.section].insert("Remove", at: indexPath.row)
            let placeholder = labelTitles[indexPath.section][indexPath.row][1]
            let usedTags = labelTitles[indexPath.section].map{$0[0]}
            let tagName = store.tags.first(where: { !usedTags.contains($0) }) ?? "home"
            labelTitles[indexPath.section].insert([tagName, placeholder], at: indexPath.row)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cellIdentifires[indexPath.section].remove(at: indexPath.row)
            labelTitles[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
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
        let alertController = UIAlertController(title: "Are you shure you want to discard your changes?",
                                                message: nil,
                                                preferredStyle: .actionSheet)
        
        alertController.modalPresentationStyle = .popover
        alertController.popoverPresentationController?.barButtonItem = sender
        
        let discardChanges = UIAlertAction(title: "Discard Changes", style: .destructive) { _ in
            print("Discard")
            self.dismiss(animated: true)
        }
        alertController.addAction(discardChanges)

        let keepEditing = UIAlertAction(title: "Keep Editing", style: .cancel, handler: nil)
        alertController.addAction(keepEditing)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
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
}
