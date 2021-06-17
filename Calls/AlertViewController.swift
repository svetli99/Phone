import UIKit

class AlertViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var store = ContactStore.shared
    @IBOutlet var containerView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var viewHeghtContraint: NSLayoutConstraint!
    
    var contact: Contact!
    var numbers: [ContactInfoItem]!
    var emails: [ContactInfoItem]!
    
    
    var labels = [(type: String, value: String)]()
    var basicIdentifiers = [String]()
    var cellIdentifiers = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = rowHeight
        
        numbers = contact.noAttributesItems.phone
        emails = contact.noAttributesItems.email
        
        if numbers != nil {
            basicIdentifiers.append(contentsOf: ["Call","Message","Video"])
        }
        if emails != nil {
            basicIdentifiers.append("Mail")
        }
        cellIdentifiers = basicIdentifiers
        
        viewHeghtContraint.constant = CGFloat(cellIdentifiers.count) * rowHeight + 60
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabBar = presentingViewController as? UITabBarController,
           let navVC = tabBar.selectedViewController as? UINavigationController,
           let contactInfoVC = navVC.topViewController as? ContactInfoViewController {
            contactInfoVC.viewWillAppear(true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellIdentifiers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifiers[indexPath.row], for: indexPath)
        switch cell {
        case let custom as WayCell:
            custom.label.text = cellIdentifiers[indexPath.row]
            let width = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 ? cell.bounds.size.width : 15
            custom.separatorInset = UIEdgeInsets(top: 0, left: width, bottom: 0, right: 0)
            cell = custom
        case let custom as TypeCell:
            custom.type.text = labels[indexPath.row  - 1].type
            custom.number.text = labels[indexPath.row  - 1].value
            let width = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 ? cell.bounds.size.width : 15
            custom.separatorInset = UIEdgeInsets(top: 0, left: width, bottom: 0, right: 0)
            cell = custom
        default:
            break
        }
        return cell
    }
    var isCellOpen = false
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let custom = cell as? WayCell {
            if isCellOpen {
                cellIdentifiers = basicIdentifiers
                self.viewHeghtContraint.constant = CGFloat(self.cellIdentifiers.count) * rowHeight + 40
                UIView.animate(withDuration: 0.3, animations: {
                    //custom.chevronDown.transform = CGAffineTransform.identity
                    self.containerView.layoutIfNeeded()
                })
                UIView.animate(withDuration: 0.3, animations: {
                    custom.chevronDown.transform = CGAffineTransform.identity
                    //self.containerView.layoutIfNeeded()
                })
            } else {
                cellIdentifiers = [cellIdentifiers[indexPath.row]]
                addRows(custom.label.text!)
                self.viewHeghtContraint.constant = CGFloat(self.cellIdentifiers.count) * rowHeight + 40
                
                UIView.animate(withDuration: 0.3, animations: {
                    //custom.chevronDown.transform = CGAffineTransform(rotationAngle: .pi)
                    self.containerView.layoutIfNeeded()
                })
                UIView.animate(withDuration: 0.3, animations: {
                    custom.chevronDown.transform = CGAffineTransform(rotationAngle: .pi)
                    //self.containerView.layoutIfNeeded()
                })
            }
            isCellOpen.toggle()
        }
        if cell is TypeCell {
            let favType = cellIdentifiers.first
            if favType == "Mail" {
                contact.noAttributesItems.email?[indexPath.row  - 1].isFavourite?.toggle()
                contact.noAttributesItems.email?[indexPath.row  - 1].favouriteDate = Date()
                contact.noAttributesItems.email?[indexPath.row  - 1].favouriteType = favType
            } else {
                contact.noAttributesItems.phone?[indexPath.row  - 1].isFavourite?.toggle()
                contact.noAttributesItems.phone?[indexPath.row  - 1].favouriteDate = Date()
                contact.noAttributesItems.phone?[indexPath.row  - 1].favouriteType = favType
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
        cellIdentifiers.append(contentsOf: Array(repeating: "Type", count: labels.count))
    }
}

class WayCell: UITableViewCell {
    @IBOutlet var label: UILabel!
    @IBOutlet var chevronDown: UIImageView!
}

class TypeCell: UITableViewCell {
    @IBOutlet var type: UILabel!
    @IBOutlet var number: UILabel!
}
