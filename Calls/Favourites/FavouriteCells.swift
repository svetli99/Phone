import UIKit

class FavouriteCell: UITableViewCell {
    @IBOutlet var IDLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var type: UILabel!
    var favouriteType: String!
    
    override func updateConstraints() {
        super.updateConstraints()
        
        separatorInset.left = nameLabel.frame.minX
    }
}
