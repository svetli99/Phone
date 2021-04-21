//
//  ViewController.swift
//  Calls
//
//  Created by Svetlio on 16.04.21.
//

import UIKit

class RecentViewController: UITableViewController {
    var callStore = CallStore()
    
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
        formatter.dateFormat = "EEEE"
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
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeContentTitle = "Recentssss"
        navigationController?.navigationBar.backgroundColor = tableView.backgroundColor
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.leftBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem?.title = ""
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        callStore.getNumberOfRows(segmentedIndex: segmentedControl.selectedSegmentIndex)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->         UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CallCell", for: indexPath) as! CallCell
        let call = callStore.getCall(segmentedIndex: segmentedControl.selectedSegmentIndex, row: indexPath.row)
        cell.nameLabel.text = call.name
        cell.nameLabel.textColor = call.isMissed ? .red : .black
        cell.phoneTypeLabel.text = call.phoneType
        cell.dateLabel.text = dateFormatterName.string(from: call.date)
        cell.icon.isHidden = !call.hasIcon
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            callStore.deleteCall(segmentedIndex: segmentedControl.selectedSegmentIndex, row: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc func callTypeChanged() {
        tableView.reloadData()
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
    
    func pickDateFormatter() {
        let date = Date()
        
    }
}

