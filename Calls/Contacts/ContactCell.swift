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
class ProfileView: UIView {
    @IBOutlet var iDLabel: UILabel!
    @IBOutlet var name: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
    class func fromNib() -> Self {
        return Bundle(for: Self.self).loadNibNamed(String(describing: Self.self), owner: nil, options: nil)![0] as! Self
    }
}

class CallInfoCell: UITableViewCell {
    @IBOutlet var day: UILabel!
    @IBOutlet var stackView: UIStackView!
    
    func addCall(time: String, type: String, duration: String) {
        let newView = CallInfoView.fromNib()
        newView.time.text = time
        newView.type.text = type
        newView.duration.text = duration
        newView.duration.isHidden = duration == "0"
        stackView.addArrangedSubview(newView)
    }
}

class CallInfoView: UIView {
    @IBOutlet var time: UILabel!
    @IBOutlet var type: UILabel!
    @IBOutlet var duration: UILabel!
    
    class func fromNib() -> Self {
        return Bundle(for: Self.self).loadNibNamed(String(describing: Self.self), owner: nil, options: nil)![0] as! Self
    }
}

class InfoCell: UITableViewCell {
    @IBOutlet var type: UILabel!
    @IBOutlet var number: UILabel!
    @IBOutlet var isFavourite: UIImageView!
    @IBOutlet var recent: UIView!
}

class ButtonCell: UITableViewCell {
    @IBOutlet var label: UILabel!
}

class NotesCell: UITableViewCell {
    @IBOutlet var textField: MyTextField!
}

class AddressInfoCell: UITableViewCell {
    @IBOutlet var type: UILabel!
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
    @IBOutlet var typeButton: UIButton!
    @IBOutlet var textField: MyTextField!
    @IBOutlet var textFieldView: LineView!{
        didSet {
            textFieldView.addLeftLine()
        }
    }
    
    @IBOutlet var leadingChevronConstraint: NSLayoutConstraint!
}

class AddressCell: UITableViewCell {
    @IBOutlet var typeButton: UIButton!
    @IBOutlet var street1: MyTextField!
    @IBOutlet var street1View: LineView!{
        didSet {
            street1View.addLeftLine()
        }
    }
    @IBOutlet var street2: MyTextField!
    @IBOutlet var street2View: LineView!{
        didSet {
            street2View.addLeftLine()
        }
    }
    @IBOutlet var postCode: MyTextField!
    @IBOutlet var postCodeView: LineView!{
        didSet {
            postCodeView.addLeftLine()
        }
    }
    @IBOutlet var city: MyTextField!
    @IBOutlet var cityView: LineView!{
        didSet {
            cityView.addLeftLine()
        }
    }
    @IBOutlet var country: MyTextField!
    @IBOutlet var countryView: LineView!{
        didSet {
            countryView.addLeftLine()
        }
    }
    
    @IBOutlet var leadingChevronConstraint: NSLayoutConstraint!
    

}

class AddCell: UITableViewCell {
    @IBOutlet var label: UILabel!
}

// MARK: Tags
class AddTypeCell: UITableViewCell {
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
}
