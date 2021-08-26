import UIKit
import RxSwift
import RxCocoa

protocol LocationView: AnyObject {
    func bindCollectionView(with locations: [LocationModel])
}
private let reuseIdentifier = "LocationCell"

class LocationCollectionViewController: UICollectionViewController {

    var locationPresenter = LocationPresenter(model: LocationResponseModel())

    let disposeBag = DisposeBag()
    let searchController = UISearchController()
    let search = BehaviorSubject(value: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationPresenter.attachView(view: self)
        locationPresenter.loadLocations()
        
        collectionView.setCollectionViewLayout(generateLayout(), animated: false)
        collectionView.dataSource = nil

        configureSearchController()
        setupCellTapHandling()
        setupScrolling()
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
            heightDimension: .fractionalHeight(0.20)
        )
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
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
    
    func setupCellTapHandling() {
        collectionView
            .rx
            .modelSelected(LocationModel.self)
            .subscribe(onNext: { [unowned self] location in
                print("tapped \(location.name)")
            })
            .disposed(by: disposeBag)
    }
    
    func setupScrolling() {
        collectionView.rx.didScroll.subscribe { [weak self] _ in
            guard let self = self else { return }
            let offSetY = self.collectionView.contentOffset.y
            let contentHeight = self.collectionView.contentSize.height

            if offSetY > (contentHeight - self.collectionView.frame.size.height - 100) {
                self.locationPresenter.didScroll()
            }
        }
    }
    
    func setupSearch() {
//        let results = searchController.searchBar.rx.text.orEmpty
//            .throttle(RxTimeInterval(0.5), scheduler: MainScheduler.instance)
//            .distinctUntilChanged()
//            .flatMapLatest { query -> Observable<NflPlayerStats> in
//          if query.isEmpty {
//            return .just([])
//          }
//          return ApiController.shared.search(search: query)
//            .catchErrorJustReturn([])
//        }
//        .observeOn(MainScheduler.instance)
//
//      results
//        .bind(to: collectionView.rx.items(cellIdentifier: reuseIdentifier, cellType: LocationCollectionViewCell.self)) {
//          (index, location, cell) in
//          cell.setup(for: location)
//        }
//        .disposed(by: disposeBag)

    }

}


extension LocationCollectionViewController: LocationView {

    func bindCollectionView(with locations: [LocationModel]) {
        
        collectionView.dataSource = nil
        
        let items = Observable<[LocationModel]>.of(locations)
        
        items.bind(to: collectionView.rx.items(cellIdentifier: reuseIdentifier)) { indexPath, location, cell in
                if let cellToUse = cell as? LocationCollectionViewCell {
                    cellToUse.locationNameLabel.text = location.name
                    cellToUse.locationTypeLabel.text = location.type
                
                    cell.layer.cornerRadius = 18.0
            
                }
            }
            .disposed(by: disposeBag)
        
    }
}

extension LocationCollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        search.onNext(searchController.searchBar.text ?? "")
    }
   
}
