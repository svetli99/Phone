import UIKit

class AlertViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var store = ContactStore.shared
    @IBOutlet var containerView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var viewHeghtContraint: NSLayoutConstraint!
    
    var contact: Contact!
    var numbers: [ContactInfoItem]!
    var emails: [ContactInfoItem]!
    
    var wayPressed = ""
    var rowOfWayPressed = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = rowHeight
        
        numbers = contact.noAttributesItems.phone
        emails = contact.noAttributesItems.email
        if numbers != nil {
            cellIdentifires.append(contentsOf: ["Call","Message","Video"])
        }
        if emails != nil {
            cellIdentifires.append("Mail")
        }
        
        viewHeghtContraint.constant = CGFloat(cellIdentifires.count) * rowHeight + 60
    }
    
    var labels = [(type: String, value: String)]()
    var cellIdentifires = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellIdentifires.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifires[indexPath.row], for: indexPath)
        switch cell {
        case let custom as WayCell:
            custom.label.text = cellIdentifires[indexPath.row]
            let width = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 ? cell.bounds.size.width : 15
            custom.separatorInset = UIEdgeInsets(top: 0, left: width, bottom: 0, right: 0)
            cell = custom
        case let custom as TypeCell:
            custom.type.text = labels[indexPath.row - rowOfWayPressed - 1].type
            custom.number.text = labels[indexPath.row - rowOfWayPressed - 1].value
            let width = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 ? cell.bounds.size.width : 15
            custom.separatorInset = UIEdgeInsets(top: 0, left: width, bottom: 0, right: 0)
            cell = custom
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let custom = cell as? WayCell {
            if custom.chevronDown.isHidden {
                removeRows()
                UIView.animate(withDuration: 0.3, animations: {
                    custom.chevronUp.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                    self.containerView.translatesAutoresizingMaskIntoConstraints = false
                    self.viewHeghtContraint.constant = CGFloat(self.cellIdentifires.count) * rowHeight + 40
                    self.containerView.layoutIfNeeded()
                }, completion: { _ in
                    custom.chevronDown.isHidden.toggle()
                    custom.chevronUp.isHidden.toggle()
                })
                rowOfWayPressed = 0
                wayPressed = ""
            } else {
                if wayPressed != "" {
                    removeRows()
                }
                
                rowOfWayPressed = indexPath.row
                addRows(custom.label.text!)
                
                UIView.animate(withDuration: 0.3, animations: {
                    custom.chevronDown.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                    self.containerView.translatesAutoresizingMaskIntoConstraints = false
                    self.viewHeghtContraint.constant = CGFloat(self.cellIdentifires.count) * rowHeight + 40
                    self.containerView.layoutIfNeeded()
                }, completion: { _ in
                    custom.chevronDown.isHidden.toggle()
                    custom.chevronUp.isHidden.toggle()
                })
                wayPressed = custom.label.text!
            }
        }
        if cell is TypeCell {
            if wayPressed == "Mail" {
                contact.noAttributesItems.email?[indexPath.row - rowOfWayPressed - 1].isFavourite?.toggle()
                contact.noAttributesItems.email?[indexPath.row - rowOfWayPressed - 1].favouriteDate = Date()
                contact.noAttributesItems.email?[indexPath.row - rowOfWayPressed - 1].favouriteType = wayPressed
            } else {
                contact.noAttributesItems.phone?[indexPath.row - rowOfWayPressed - 1].isFavourite?.toggle()
                contact.noAttributesItems.phone?[indexPath.row - rowOfWayPressed - 1].favouriteDate = Date()
                contact.noAttributesItems.phone?[indexPath.row - rowOfWayPressed - 1].favouriteType = wayPressed
            }
            store.parseToJSON(contact)
            store.updateFavourites()
            dismiss(animated: true)
        }
    }
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    private func addRows(_ way: String) {
        labels = way == "Mail" ? emails.map { ($0.type,$0.value) } : numbers.map{ ($0.type,$0.value) }
        cellIdentifires.insert(contentsOf: Array(repeating: "Type", count: labels.count), at: rowOfWayPressed + 1)
    }
    
    private func removeRows() {
        cellIdentifires = cellIdentifires.filter { $0 != "Type" }
    }
    
}

class WayCell: UITableViewCell {
    @IBOutlet var label: UILabel!
    @IBOutlet var chevronDown: UIImageView!
    @IBOutlet var chevronUp: UIImageView!
}

class TypeCell: UITableViewCell {
    @IBOutlet var type: UILabel!
    @IBOutlet var number: UILabel!
}
