import Foundation

//protocol SectionViewPresenter {
//    //init(view: SectionView)
//    func viewDidLoad()
//    func didSelectItem(indexPath: IndexPath)
//}

class SectionPresenter {
    
    var sectionView: SectionView? //need to be weak
    var sections : SectionModel
    
    init (model: SectionModel) {
        self.sections = model
    }
    
    func attachView(view: SectionView?) {
        self.sectionView = view
    }
    
    func viewDidLoad() {
        retrieveURLs()
    }
    
    func didSelectItem(indexPath: IndexPath) {
        sectionView?.openNewScreen(indexPath: indexPath)
    }
    
    
    // MARK: - Private methods
    private func retrieveURLs() {

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
    }
    
}
