//
//  ViewController.swift
//  Calls
//
//  Created by Svetlio on 16.04.21.
//

import UIKit

class RecentViewController: UITableViewController {
    var callStore = CallStore.shared
    var contactStore = ContactStore.shared
    
    var segmentedControl = UISegmentedControl()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 50
        let callTypes = [
            "All",
            "Missed"
        ]
        segmentedControl = UISegmentedControl(items: callTypes)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(callTypeChanged), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.titleView = segmentedControl
        navigationController?.navigationBar.prefersLargeTitles = true
       // navigationController?.navigationBar.backgroundColor = tableView.backgroundColor
        //navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.leftBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem?.title = ""
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        callStore.getNumberOfRows(segmentedIndex: segmentedControl.selectedSegmentIndex)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->         UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CallCell", for: indexPath) as! CallCell
        let call = callStore.getCall(segmentedIndex: segmentedControl.selectedSegmentIndex, row: indexPath.row)
        cell.nameLabel.text = call.first!.name! + (call.count > 1 ? "(\(call.count))" : "")
        cell.nameLabel.textColor = call.first?.callType == "Missed" ? .red : .black
        cell.phoneTypeLabel.text = call.first?.phoneType
        cell.dateLabel.text = dateFormatting(call.first!.date!)
        cell.icon.isHidden = call.first?.callType != "OutGoing"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            callStore.deleteCall(segmentedIndex: segmentedControl.selectedSegmentIndex, index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        performSegue(withIdentifier: "Info", sender: indexPath)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.navigationItem.leftBarButtonItem?.isEnabled = isEditing
        self.navigationItem.leftBarButtonItem?.title = isEditing ? "Clear" : ""
    }
    
    @objc func callTypeChanged() {
        tableView.reloadData()
        
    }
    
    @IBAction func clear() {
        callStore.allCalls.removeAll()
        tableView.reloadData()
    }
    
    func setEptyPage() {
        let emptyLabel = UILabel()
        emptyLabel.text = "No Recents"
        
        tableView.separatorStyle = .none
        tableView.addSubview(emptyLabel)
        emptyLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
        emptyLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
    }
    
    func restore() {
        
    }
    
    func dateFormatting(_ date: Date) -> String {
        let startOfToday = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        if startOfToday < date {
            return dateFormatterHours.string(from: date)
        }
        if startOfToday.advanced(by: -60 * 60 * 24) < date {
            return "Yesterday"
        }
        if startOfToday.advanced(by: -60 * 60 * 24 * 6) < date {
            return dateFormatterName.string(from: date)
        }
        return dateFormatterDate.string(from: date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "CallViewController" :
            if let row = tableView.indexPathForSelectedRow?.row {
                let callViewController = segue.destination as! CallViewController
                let call = callStore.getCall(segmentedIndex: segmentedControl.selectedSegmentIndex, row: row)
                callViewController.name = call.first?.name
                callViewController.type = call.first?.phoneType
                callViewController.number = call.first?.number
            }
            case "Info":
                if let indexPath = sender as? IndexPath {
                    let contactInfoViewController = segue.destination as! ContactInfoViewController
                    let call = callStore.getCall(segmentedIndex: segmentedControl.selectedSegmentIndex, row: indexPath.row)
                    let conatct = contactStore.getContact(for: call.first!.number! )
                    contactInfoViewController.contact = conatct
                    contactInfoViewController.call = call
                }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}

