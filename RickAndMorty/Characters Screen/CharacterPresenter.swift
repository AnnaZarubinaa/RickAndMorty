import Foundation
import UIKit

class CharacterPresenter {
    
    var characterView: CharacterView? //need to be weak
    
    var characterResponse: CharacterResponseModel
    var charactersImages = [Int : UIImage]()
    
    var filteredCharacters: CharacterResponseModel
    lazy var filteredImages = [Int : UIImage]()
    var isbeingFiltered = false
    var isDataRetrieving = false
    
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
    
    func retrieveCharacters(from url: String, isFiltered: Bool) {
        let charactersInfoRequest = CharacterInfoApiRequest()
        isDataRetrieving = true
        NetworkService.shared.fetchData(charactersInfoRequest, url: url) {
            (result) in
                switch result {
                case .success(let charactersInfo):
                    DispatchQueue.main.async {
                        if isFiltered {
                            self.filteredCharacters = self.filteredCharacters.clear()
                            self.filteredCharacters.info = charactersInfo.info
                            //self.filteredCharacters = self.filteredCharacters.clear()
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
    
    func didScroll(scrollView: UIScrollView, collectionViewHeight: CGFloat) {
        let position = scrollView.contentOffset.y
        if !isbeingFiltered && (position > (collectionViewHeight - 100 - scrollView.frame.size.height)) && self.characterResponse.info.next != nil && isDataRetrieving == false {
            retrieveCharacters(from: self.characterResponse.info.next!, isFiltered: false)
        }
    }
    
    func updateSearchResult(for searchController: UISearchController) {
        if let searchString = searchController.searchBar.text,
           searchString.isEmpty == false {
            isbeingFiltered = true
            let searchUrl = SectionURL.shared.characters + "?name=" + searchString.replacingOccurrences(of: " ", with: "%20")
            print(searchUrl)
            retrieveCharacters(from: searchUrl, isFiltered: true)
        } else {
            isbeingFiltered = false
            self.characterView?.reloadData()
        }
    }
}
