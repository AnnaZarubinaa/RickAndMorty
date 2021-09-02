import UIKit

private let reuseIdentifier = "Cell"

class EpisodesCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.popViewController(animated: false)
        let nothingHereScreen =  storyboard?.instantiateViewController(withIdentifier: "NothingHere") as! NothingHereViewController
        navigationController?.pushViewController(nothingHereScreen, animated: false)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

}
