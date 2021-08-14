import UIKit

private let reuseIdentifier = "SectionCell"

protocol SectionView {
    func onItemsRetrieval(data: SectionModel)
}



class SectionCollectionViewController: UICollectionViewController, SectionView {

    var presenter = SectionPresenter(model: SectionModel())
    var sections = SectionModel()

    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.setCollectionViewLayout(generateLayoutForPortraitMode(), animated: false)

        presenter.viewDidLoad()
    }
    
    func generateLayoutForPortraitMode() -> UICollectionViewLayout {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    func onItemsRetrieval(data: SectionModel) {
        print("View recieves the result from the Presenter.")
        self.sections = data
        self.collectionView.reloadData()
    }
    
}

//extension SectionCollectionViewController: SectionView {
//    func onItemsRetrieval(data: SectionModel) {
//        print("View recieves the result from the Presenter.")
//        self.sections = data
//        self.collectionView.reloadData()
//    }
//
//
//}

extension SectionCollectionViewController {
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return sections.sectionsName.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SectionCollectionViewCell
    
        cell.sectionLabel.text = sections.sectionsName[indexPath.row]
        cell.sectionImageView.image = UIImage(named: sections.sectionsImages[indexPath.row])
        cell.layer.cornerRadius = 18.0
        
        return cell
    }
}
