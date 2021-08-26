import Foundation
import UIKit

class LocationPresenter {
    weak var locationView: LocationView?
    var locationResponse: LocationResponseModel
    
    var isDataRetrieving = false
    
    init (model: LocationResponseModel) {
        self.locationResponse = model
    }
    
    func attachView(view: LocationView?) {
        self.locationView = view
    }
    
    func loadLocations() {
        retrieveLocations(from: SectionURL.shared.locations)
    }
    
    func retrieveLocations(from url: String) {
        let locationsInfoRequest = LocationInfoApiRequest()
        isDataRetrieving = true
        NetworkService.shared.fetchData(locationsInfoRequest, url: url) {
            (result) in
                switch result {
                case .success(let locationsInfo):
                    DispatchQueue.main.async {
                        self.locationResponse.info = locationsInfo.info
                        self.locationResponse.results.append(contentsOf: locationsInfo.results)
                        self.locationView?.bindCollectionView(with: self.locationResponse.results)
                        print("in retrieve: \(locationsInfo.info)")
                        self.isDataRetrieving = false
                    }
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async {
                        self.locationView?.bindCollectionView(with: [])
                    }
                    self.isDataRetrieving = false
            }
        }
    }
    
    func didScroll() {
        retrieveLocations(from: self.locationResponse.info.next ?? " ")
    }
}
