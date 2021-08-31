import UIKit

private let reuseIdentifier = "CharacterCell"

protocol CharacterView: AnyObject {
    func reloadData()
    func updateData(with characters: [CharacterModel])
    func updateImages(with images: [Int : UIImage])
}

protocol FilterDataDelegate: AnyObject {
    func updateFilterData(status: Set<String> , gender: Set<String>, cellsIndexPaths: Set<IndexPath> )
}

class CharacterCollectionViewController: UICollectionViewController {
    
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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        characterPresenter.loadCharacters()
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
  
    // MARK: UICollectionViewDelegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        characterPresenter.didScroll(scrollView: scrollView, collectionViewHeight: collectionView.contentSize.height)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationFilter = segue.destination as? FilterTableViewController {
            destinationFilter.filterPresenter.delegate = self
            destinationFilter.filterPresenter.savedCellsIndexPaths = characterPresenter.savedCellsIndexPaths
            destinationFilter.filterPresenter.filters.status = characterPresenter.statusFilters
            destinationFilter.filterPresenter.filters.gender = characterPresenter.genderFilters
        }
        
        if let destinationDetails = segue.destination as? CharacterDetailsViewController,
           let indexPath = collectionView.indexPathsForSelectedItems {
             //let currentCell = collectionView.cellForItem(at: indexPath[0])
             destinationDetails.characterDetailsPresenter.character = characters[indexPath[0].row]
             destinationDetails.characterDetailsPresenter.characterImage = images[indexPath[0].row + 1] ?? UIImage()
        }
    }

}

extension CharacterCollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.isActive {
            characterPresenter.updateSearchResult(for: searchController)
        }
    }
    
}

extension CharacterCollectionViewController: FilterDataDelegate {
    func updateFilterData(status: Set<String>, gender: Set<String>, cellsIndexPaths: Set<IndexPath>) {
        characterPresenter.updateFilterData(status: status, gender: gender, cellsIndexPaths: cellsIndexPaths)
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
