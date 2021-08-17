import UIKit

private let reuseIdentifier = "CharacterCell"

protocol CharacterView {
    func reloadData()
    func updateData(with characters: [CharacterModel])
    func updateImages(with images: [Int : UIImage])
}

class CharacterCollectionViewController: UICollectionViewController, UISearchResultsUpdating {
    
    let characterPresenter = CharacterPresenter(model: CharacterResponseModel())
    let searchController = UISearchController()
    
    var numberOfItemsInSection = 0
    var characters = [CharacterModel]()
    var images = [Int : UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.setCollectionViewLayout(generateLayout(), animated: false)
        
        configureSearchController()
        
        characterPresenter.attachView(view: self)
        characterPresenter.viewDidLoad()

    }
    
    func generateLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 30
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: spacing,
            bottom: 0,
            trailing: 0
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.3)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2
        )
        
        group.contentInsets = NSDirectionalEdgeInsets(
            top: spacing,
            leading: 0,
            bottom: 0,
            trailing: spacing
        )
        
        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
            
    }
    func configureSearchController() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Enter name"
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor(named: "Title")
    }
    
    func configureCell(cell: CharacterCollectionViewCell) {
        cell.layer.cornerRadius = 18.0
        cell.characterCellLabel.textColor = UIColor(named: "Background")
        cell.characterCellLabel.backgroundColor = UIColor.white.withAlphaComponent(0.6)
    }

    func updateSearchResults(for searchController: UISearchController) {
        characterPresenter.updateSearchResult(for: searchController)
    }

    // MARK: UICollectionViewDelegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        characterPresenter.didScroll(scrollView: scrollView, collectionViewHeight: collectionView.contentSize.height)
    }

}

extension CharacterCollectionViewController: CharacterView {
    
    func reloadData() {
        self.collectionView.reloadData()
    }
    
    func updateData(with characters: [CharacterModel]) {
        numberOfItemsInSection = characters.count
        self.characters = characters
        self.collectionView.reloadData()
    }
    
    func updateImages(with images: [Int : UIImage]) {
        self.images = images
        self.collectionView.reloadData()
    }
}

extension CharacterCollectionViewController {
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsInSection
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CharacterCollectionViewCell
        
        cell.characterCellLabel.text = characters[indexPath.row].name
        
        if let image = images[characters[indexPath.row].id] {
            cell.characterCellImageView.image = image
        }
        
        configureCell(cell: cell)
    
        return cell
    }
}
