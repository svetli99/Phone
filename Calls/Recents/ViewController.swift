//
//  ViewController.swift
//  Calls
//
//  Created by Svetlio on 16.04.21.
//

import UIKit

class ViewController: UITableViewController {
    var callStore = CallStore()
    
    var segmentedControl = UISegmentedControl()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .short
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 50
        callStore.loadCalls()
        
        let callTypes = [
            "All",
            "Missed"
        ]
        
        segmentedControl = UISegmentedControl(items: callTypes)
        segmentedControl.backgroundColor = .systemBackground
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(callTypeChanged), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.titleView = segmentedControl
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        self.navigationItem.leftBarButtonItem?.title = ""
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        callStore.getNumberOfRows(segmentedIndex: segmentedControl.selectedSegmentIndex)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->         UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CallCell", for: indexPath) as! CallCell
        let call = callStore.getCall(segmentedIndex: segmentedControl.selectedSegmentIndex, row: indexPath.row)
        print("segmentedIndex:", segmentedControl.selectedSegmentIndex, "row:", indexPath.row)
        cell.nameLabel.text = call.name
        if call.isMissed {
            cell.nameLabel.textColor = .red
        }
        cell.phoneTypeLabel.text = call.phoneType
        cell.dateLabel.text = dateFormatter.string(from: call.date)
        if !call.hasIcon {
            cell.icon.isHidden = true
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print(indexPath)
        if editingStyle == .delete {
            callStore.deleteCall(segmentedIndex: segmentedControl.selectedSegmentIndex, row: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc func callTypeChanged() {
        tableView.reloadData()
        print(callStore.allCalls.count)
        callStore.allCalls.forEach { print($0.isMissed) }
    }
    
    @IBAction func edit() {
        isEditing.toggle()
        if isEditing {
            navigationItem.rightBarButtonItem?.title = "Done"
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            self.navigationItem.leftBarButtonItem?.title = "Clear"
        } else {
            navigationItem.rightBarButtonItem?.title = "Edit"
            navigationItem.leftBarButtonItem?.isEnabled = false
            navigationItem.leftBarButtonItem?.title = ""
        }
    }
    
    @IBAction func clear() {
        callStore.allCalls.removeAll()
        tableView.reloadData()
    }
}

