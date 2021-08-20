import Foundation
import UIKit

class CharacterPresenter {
    
    weak var characterView: CharacterView?
    
    
    var characterResponse: CharacterResponseModel
    var charactersImages = [Int : UIImage]()
    
    var filteredCharacters: CharacterResponseModel
    lazy var filteredImages = [Int : UIImage]()
    var isbeingFiltered = false
    var isDataRetrieving = false
    
    var statusFilters = Set<String>()
    var genderFilters = Set<String>()
    var savedCellsIndexPaths  = Set<IndexPath>()
    
    init (model: CharacterResponseModel ) {
        self.characterResponse = model
        self.filteredCharacters = model
    }
    
    func attachView(view: CharacterView?) {
        self.characterView = view
    }
    
    func viewDidLoad() {
        retrieveCharacters(from: SectionURL.shared.characters, isFiltered: false)
    }

    func updateFilterData(status: Set<String>, gender: Set<String>, cellsIndexPaths: Set<IndexPath>) {
        statusFilters = status
        genderFilters = gender
        savedCellsIndexPaths = cellsIndexPaths
    }

    
    func retrieveCharacters(from url: String, isFiltered: Bool) {
        let charactersInfoRequest = CharacterInfoApiRequest()
        isDataRetrieving = true
        NetworkService.shared.fetchData(charactersInfoRequest, url: url) {
            (result) in
                switch result {
                case .success(let charactersInfo):
                    DispatchQueue.main.async {
                        if isFiltered {
                            self.filteredCharacters.info = charactersInfo.info
                            self.filteredCharacters.results.append(contentsOf: charactersInfo.results)
                            print("SEARCH: \(self.filteredCharacters.info)")
                            self.characterView?.updateData(with: self.filteredCharacters.results)
                            self.retrieveImages(for: charactersInfo.results, isFiltered: true)
                        } else {
                            self.characterResponse.info = charactersInfo.info
                            self.characterResponse.results.append(contentsOf: charactersInfo.results)
                            self.characterView?.updateData(with: self.characterResponse.results)
                            self.retrieveImages(for: charactersInfo.results, isFiltered: false)
                        }
                        
                        self.isDataRetrieving = false
                    }
                case .failure(let error):
                    print(error)
                    self.isDataRetrieving = false
            }
        }
    }
    
    func retrieveImages(for characters: [CharacterModel], isFiltered: Bool) {
        for item in 0 ..< characters.count {
            NetworkService.shared.fetchImage(from: characters[item].image) {
                (result) in
                    switch result {
                    case .success(let characterImage):
                        DispatchQueue.main.async {
                            if isFiltered {
                                self.filteredImages[characters[item].id] = characterImage
                                self.characterView?.updateImages(with: self.filteredImages)
                            } else {
                                self.charactersImages[characters[item].id] = characterImage
                                self.characterView?.updateImages(with: self.charactersImages)
                            }
                            
                        }
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
    
    func filterCharacters() {
        guard !statusFilters.isEmpty || !genderFilters.isEmpty else { return }

        let searchUrl = SectionURL.shared.characters + "/?" + getFilterUrlString()
        print("search url \(searchUrl)")
        isbeingFiltered = true
        self.filteredCharacters = self.filteredCharacters.clear()
        retrieveCharacters(from: searchUrl, isFiltered: true)
        
    }
    
    func didScroll(scrollView: UIScrollView, collectionViewHeight: CGFloat) {
        let position = scrollView.contentOffset.y
        if (position > (collectionViewHeight - 100 - scrollView.frame.size.height)) && self.characterResponse.info.next != nil && isDataRetrieving == false {
            
            if isbeingFiltered {
                print("fetch characters")
                retrieveCharacters(from: self.filteredCharacters.info.next ?? " ", isFiltered: true)
            } else {
                retrieveCharacters(from: self.characterResponse.info.next ?? " ", isFiltered: false)
            }
            
        }
    }
    
    func updateSearchResult(for searchController: UISearchController) {
        if let searchString = searchController.searchBar.text,
           searchString.isEmpty == false {
            isbeingFiltered = true
            var searchUrl = SectionURL.shared.characters + "/?name=" + searchString.replacingOccurrences(of: " ", with: "%20")
            if !statusFilters.isEmpty || !genderFilters.isEmpty {
                searchUrl += "&" + getFilterUrlString()
            }
            print(searchUrl)
            self.filteredCharacters = self.filteredCharacters.clear()
            retrieveCharacters(from: searchUrl, isFiltered: true)
        } else {
            isbeingFiltered = false
            //viewDidLoad()
        }
    }
    
    func getFilterUrlString() -> String {
        let statusString = "status=" + statusFilters.joined(separator: "&")
        let genderString = "gender=" + genderFilters.joined(separator: "&")
        return statusString + "&" + genderString
    }
}
