import UIKit
import CoreData

class TagDataSource: NSObject, UITableViewDataSource {
    var tags = [String]()
    let identifires = ["TagCell", "Add"]
    var otherLabels = ["Add Custom Label", "other"]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        identifires.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch identifires[section] {
        case "TagCell" : return tags.count
        case "Add" : return otherLabels.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifire = identifires[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: identifire, for: indexPath)
        var text: String
        if identifire == "TagCell" {
            let tag = tags[indexPath.row]
            text = tag
        } else {
            text = otherLabels[indexPath.row]
        }
        cell.textLabel?.text = text
        
        return cell
    }
    
    func apendingTag(_ tag:String) {
        tags.append(tag)
    }
    
}
