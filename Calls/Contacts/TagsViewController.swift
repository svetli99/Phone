import UIKit

class TagsViewController: UITableViewController {
    let tagDataSource = TagDataSource()
    let store = ContactStore.shared
    var selectedTagIndex = 0 {
        didSet {
            selectedButton.setTitle(store.tags[selectedTagIndex], for: .normal)
        }
    }
    var selectedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = tagDataSource
        tableView.delegate = self
        updateTags()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedTagIndex == indexPath.row || indexPath.section != 0{
            return
        }
        let oldIndexPath = IndexPath(row: selectedTagIndex, section: indexPath.section)
        selectedTagIndex = indexPath.row
        
        do {
            try store.persistentContainer.viewContext.save()
        } catch {
            print("Core Data save failed: \(error).")
        }
        
        tableView.reloadRows(at: [indexPath, oldIndexPath], with: .automatic)
        dismiss(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            cell.accessoryType = selectedTagIndex == indexPath.row ? .checkmark : .none

        }
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    private func updateTags() {
        self.tagDataSource.tags = store.tags
        guard let name = selectedButton.currentTitle else {
            return
        }
        if let index = self.tagDataSource.tags.firstIndex(where: { $0 == name }) {
            self.selectedTagIndex = index
        }
        
        self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        
    }
}
