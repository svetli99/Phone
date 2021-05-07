import UIKit

class CustomKeypadDataSource: NSObject, UICollectionViewDataSource {
    var buttons: [CustomButton] = []
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        buttons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        cell.backgroundView = buttons[indexPath.row]
        print(indexPath.row)
        return cell
    }
}
