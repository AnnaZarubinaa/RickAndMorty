import UIKit

private let reuseIdentifier = "SectionCell"

protocol SectionView {
    func onItemsRetrieval(data: SectionModel)
    func openNewScreen(indexPath: IndexPath)
}

class SectionCollectionViewController: UICollectionViewController {

    let sectionPresenter = SectionPresenter(model: SectionModel())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.setCollectionViewLayout(generateLayout(), animated: false)

        sectionPresenter.attachView( view: self)
        sectionPresenter.viewDidLoad()
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 30
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: spacing,
            leading: spacing,
            bottom: 0,
            trailing: spacing
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.75)
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitem: item,
            count: 3
        )
        
        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
}

extension SectionCollectionViewController: SectionView {
    func onItemsRetrieval(data: SectionModel) {
        print("View recieves the result from the Presenter.")
        sectionPresenter.sections = data
        self.collectionView.reloadData()
    }
    
    func openNewScreen(indexPath: IndexPath){
        if indexPath.row == 0 {
            performSegue(withIdentifier: "Characters", sender: nil)
        } else if indexPath.row == 1 {
            performSegue(withIdentifier: "Locations", sender: nil)
        } else if indexPath.row == 2{
            performSegue(withIdentifier: "Episodes", sender: nil)
        }
    }
}

extension SectionCollectionViewController {
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return sectionPresenter.sections.sectionsName.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SectionCollectionViewCell
    
        cell.sectionCellLabel.text = sectionPresenter.sections.sectionsName[indexPath.row]
        cell.sectionCellImageView.image = UIImage(named: sectionPresenter.sections.sectionsImages[indexPath.row])
        cell.layer.cornerRadius = 18.0
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sectionPresenter.didSelectItem(indexPath: indexPath)
    }
}
