import Foundation
import UIKit

class CharacterPresenter {
    
    weak var characterView: CharacterView?
    
    
    var characterResponse: CharacterResponseModel
    var charactersImages = [Int : UIImage]()

    var isDataRetrieving = false
    
    var statusFilters = Set<String>()
    var genderFilters = Set<String>()
    var savedCellsIndexPaths  = Set<IndexPath>()
    
    var searchUrl: String {
        return SectionURL.shared.characters + "/?" + getFilterUrlString()
    }
    
    init (model: CharacterResponseModel ) {
        self.characterResponse = model
    }
    
    func attachView(view: CharacterView?) {
        self.characterView = view
    }
    
    func loadCharacters() {
        self.characterResponse = self.characterResponse.clear()
        print(searchUrl)
        retrieveCharacters(from: searchUrl)
    }

    func updateFilterData(status: Set<String>, gender: Set<String>, cellsIndexPaths: Set<IndexPath>) {
        statusFilters = status
        genderFilters = gender
        savedCellsIndexPaths = cellsIndexPaths
    }

    
    func retrieveCharacters(from url: String) {
        let charactersInfoRequest = CharacterInfoApiRequest()
        isDataRetrieving = true
        NetworkService.shared.fetchData(charactersInfoRequest, url: url) {
            (result) in
                switch result {
                case .success(let charactersInfo):
                    DispatchQueue.main.async {
                        self.characterResponse.info = charactersInfo.info
                        self.characterResponse.results.append(contentsOf: charactersInfo.results)
                        self.characterView?.updateData(with: self.characterResponse.results)
                        self.retrieveImages(for: charactersInfo.results)
                        print("in retrieve: \(charactersInfo.info)")
                        self.isDataRetrieving = false
                    }
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async {
                        self.characterView?.updateData(with: [])
                    }
                    self.isDataRetrieving = false
            }
        }
    }
    
    func retrieveImages(for characters: [CharacterModel]) {
        for item in 0 ..< characters.count {
            NetworkService.shared.fetchImage(from: characters[item].image) {
                (result) in
                    switch result {
                    case .success(let characterImage):
                        DispatchQueue.main.async {
                            self.charactersImages[characters[item].id] = characterImage
                            self.characterView?.updateImages(with: self.charactersImages)
                        }
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
    
    func didScroll(scrollView: UIScrollView, collectionViewHeight: CGFloat) {
        let position = scrollView.contentOffset.y
        if (position > (collectionViewHeight - 100 - scrollView.frame.size.height)) && self.characterResponse.info.next != nil && isDataRetrieving == false {
            
            retrieveCharacters(from: self.characterResponse.info.next ?? " ")
        }
    }
    
    func updateSearchResult(for searchController: UISearchController) {
        var isSearchBarEmpty: Bool {
          return searchController.searchBar.text?.isEmpty ?? true
        }
        
        if let searchString = searchController.searchBar.text,
           searchString.isEmpty == false {
            let searchNameUrl = searchUrl + "&name=" + searchString.replacingOccurrences(of: " ", with: "%20")
            self.characterResponse = self.characterResponse.clear()
            retrieveCharacters(from: searchNameUrl)
        } else {
            self.characterResponse = self.characterResponse.clear()
            retrieveCharacters(from: searchUrl)
        }
        
    }
    
    func getFilterUrlString() -> String {
        let statusString = "status=" + statusFilters.joined(separator: "&")
        let genderString = "gender=" + genderFilters.joined(separator: "&")
        return statusString + "&" + genderString
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        print("Cancel")
    }
}
