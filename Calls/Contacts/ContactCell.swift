//
//  ContactCell.swift
//  Contacts
//
//  Created by Svetlio on 9.04.21.
//

import UIKit
// MARK: Contacts
class ContactCell: UITableViewCell {
    @IBOutlet var name: UILabel!
}

// MARK: Info
class NumberCell: UITableViewCell {
    @IBOutlet var tagName: UILabel!
    @IBOutlet var number: UILabel!
}

class ButtonCell: UITableViewCell {
    @IBOutlet var label: UILabel!
}

// MARK: Edit

class TextFieldCell: UITableViewCell {
    @IBOutlet var textField: UITextField!
}

class TonesCell: UITableViewCell {
    @IBOutlet var label: UILabel!
    @IBOutlet var typeLabel: UILabel!
}

class RemoveCell: UITableViewCell {
    @IBOutlet var tagButton: UIButton!
    @IBOutlet var textField: UITextField!
    
    @objc private func deleteCell(_ sender: UIButton) {
        reloadInputViews()
//        isEditing.toggle()
//        setEditing(isEditing, animated: true)
    }
}

// MARK: Tags

class AddCell: UITableViewCell {
    @IBOutlet var label: UILabel!
}
