import Foundation

protocol SectionViewPresenter {
    //init(view: SectionView)
    func viewDidLoad()
    func selectItem(with title: String)
}

class SectionPresenter: SectionViewPresenter {
    
    var sectionView: SectionView? //need to be weak
    var sections : SectionModel
    
    required init (model: SectionModel) {
        self.sections = model
    }
    
    func attachView(_ attach: Bool, view: SectionView?) {
            if attach {
                sectionView = nil
            } else {
                if let vew = view { sectionView = view }
            }
        }
    
    func viewDidLoad() {
        print("View notifies the Presenter that it has loaded.")
        retrieveURLs()
    }
    
    func selectItem(with title: String) {
        print("View notifies the Presenter that an add button was tapped.")
        //addItem(title: title) // переход на другой экран
    }
    
    
    // MARK: - Private methods
    private func retrieveURLs() {
        print("Presenter retrieves Item objects from the Database.")

        //  получение данных с сервера
        sectionView?.onItemsRetrieval(data: sections)
    }
    
}
