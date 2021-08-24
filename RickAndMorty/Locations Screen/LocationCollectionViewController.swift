import UIKit
import RxSwift
import RxCocoa

protocol LocationView: AnyObject {
    func setupCellConfigurating(with locations: [LocationModel])
}
private let reuseIdentifier = "LocationCell"

class LocationCollectionViewController: UICollectionViewController {

    var locationPresenter = LocationPresenter(model: LocationResponseModel())

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationPresenter.attachView(view: self)
        locationPresenter.loadLocations()
        
        collectionView.setCollectionViewLayout(generateLayout(), animated: false)
        collectionView.dataSource = nil
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
    
    func setupCellTapHandling() {
        collectionView
            .rx
            .modelSelected(LocationModel.self)
            .subscribe(onNext: { [unowned self] location in
                print("tapped ")
            })
            .disposed(by: disposeBag)
    }
    
    func searchRx() {
//      let results = searchBar.rx.text.orEmpty
//        .throttle(0.5, scheduler: MainScheduler.instance)
//        .distinctUntilChanged()
//        .flatMapLatest { query -> Observable<NflPlayerStats> in
//          if query.isEmpty {
//            return .just([])
//          }
//          return ApiController.shared.search(search: query)
//            .catchErrorJustReturn([])
//        }
//        .observeOn(MainScheduler.instance)
//
//      results
//        .bind(to: collectionView
//                .rx
//                .items(cellIdentifier: reuseIdentifier,
//                                          cellType: LocationCollectionViewCell.self)) {
//          (index, location, cell) in
//          cell.setup(for: location)
//        }
//        .disposed(by: disposeBag)

    }

}


extension LocationCollectionViewController: LocationView {

    func setupCellConfigurating(with locations: [LocationModel]) {
        let locationsRx = Observable.just(locations)
        
        locationsRx
            .bind(to: collectionView
                .rx
                .items(cellIdentifier: reuseIdentifier)) {
                _, location, cell in
                if let cellToUse = cell as? LocationCollectionViewCell {
                    cellToUse.locationNameLabel.text = location.name
                    cellToUse.locationTypeLabel.text = location.type
                    
                    cell.layer.cornerRadius = 18.0
                    
                }
            }
            .disposed(by: disposeBag)
    }
}
