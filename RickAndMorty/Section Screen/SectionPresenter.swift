import Foundation

//protocol SectionViewPresenter {
//    //init(view: SectionView)
//    func viewDidLoad()
//    func didSelectItem(indexPath: IndexPath)
//}

class SectionPresenter {
    
    var sectionView: SectionView? //need to be weak
    var sections : SectionModel
    
    required init (model: SectionModel ) {
        self.sections = model
    }
    
    func attachView(view: SectionView?) {
        self.sectionView = view
    }
    
    func viewDidLoad() {
        print("View notifies the Presenter that it has loaded.")
        retrieveURLs()
    }
    
    func didSelectItem(indexPath: IndexPath) {
        print("View notifies the Presenter that an add button was tapped.")
        sectionView?.openNewScreen(indexPath: indexPath)
    }
    
    
    // MARK: - Private methods
    private func retrieveURLs() {
        print("Presenter retrieves Item objects from the Database.")

        let sectionInfoRequest = SectionInfoApiRequest()
        NetworkService.shared.fetchData(sectionInfoRequest, url: NetworkService.shared.baseURL) {
            (result) in
                switch result {
                case .success(let sectionUrl):
                    SectionURL.shared.characters = sectionUrl.characters
                    SectionURL.shared.episodes = sectionUrl.episodes
                    SectionURL.shared.locations = sectionUrl.locations
                    print(SectionURL.shared)
                case .failure(let error):
                    print(error)
            }
        }
        
        //sectionView?.onItemsRetrieval(data: sections)
    }
    
}
