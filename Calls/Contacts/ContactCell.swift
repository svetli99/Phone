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

class NotesCell: UITableViewCell {
    @IBOutlet var textField: MyTextField!
}

class AddressInfoCell: UITableViewCell {
    @IBOutlet var tagName: UILabel!
    @IBOutlet var labels: [UILabel]!
}

// MARK: Edit

class TextFieldCell: UITableViewCell {
    @IBOutlet var textField: MyTextField!
}

class TonesCell: UITableViewCell {
    @IBOutlet var label: UILabel!
    @IBOutlet var typeLabel: UILabel!
}

class RemoveCell: UITableViewCell {
    @IBOutlet var tagButton: UIButton!
    @IBOutlet var textField: MyTextField!
    @IBOutlet var textFieldView: LineView!{
        didSet {
            textFieldView.addLeftLine()
        }
    }
    
    @IBOutlet var leadingChevronConstraint: NSLayoutConstraint!
    

}

class AddressCell: UITableViewCell {
    @IBOutlet var tagButton: UIButton!
    @IBOutlet var street1: MyTextField!
    @IBOutlet var street1View: LineView!{
        didSet {
            street1View.addLeftLine()
            street1View.addBottomLine()
        }
    }
    @IBOutlet var street2: MyTextField!
    @IBOutlet var street2View: LineView!{
        didSet {
            street2View.addLeftLine()
            street2View.addBottomLine()
        }
    }
    @IBOutlet var postCode: MyTextField!
    @IBOutlet var postCodeView: LineView!{
        didSet {
            postCodeView.addLeftLine()
            postCodeView.addBottomLine()
        }
    }
    @IBOutlet var city: MyTextField!
    @IBOutlet var cityView: LineView!{
        didSet {
            cityView.addLeftLine()
            cityView.addBottomLine()
        }
    }
    @IBOutlet var country: MyTextField!
    @IBOutlet var countryView: LineView!{
        didSet {
            countryView.addLeftLine()
            countryView.addBottomLine()
        }
    }
    
    @IBOutlet var leadingChevronConstraint: NSLayoutConstraint!
}

// MARK: Tags

class AddCell: UITableViewCell {
    @IBOutlet var label: UILabel!
}

class MyTextField: UITextField {
    var indexPath: IndexPath!
}

class LineView: UIView {
    func addLeftLine() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.white.cgColor, UIColor.systemGray2.cgColor]
        gradient.frame = CGRect(x: 0, y: 0, width: 1, height: self.bounds.height)
        self.layer.addSublayer(gradient)
    }
    
    func addBottomLine() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemGreen.cgColor]
        gradient.frame = CGRect(x: 0, y: 0 , width: self.bounds.width, height: 1)
        self.layer.addSublayer(gradient)
    }
}
