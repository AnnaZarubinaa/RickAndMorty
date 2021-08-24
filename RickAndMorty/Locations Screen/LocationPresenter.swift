import Foundation

class LocationPresenter {
    weak var locationView: LocationView?
    var locationResponse: LocationResponseModel
    
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
        NetworkService.shared.fetchData(locationsInfoRequest, url: url) {
            (result) in
                switch result {
                case .success(let locationsInfo):
                    DispatchQueue.main.async {
                        self.locationResponse.info = locationsInfo.info
                        self.locationResponse.results.append(contentsOf: locationsInfo.results)
                        self.locationView?.setupCellConfigurating(with: self.locationResponse.results)
                        print("in retrieve: \(locationsInfo.info)")
                    }
                case .failure(let error):
                    print(error)
                    DispatchQueue.main.async {
                        self.locationView?.setupCellConfigurating(with: [])
                    }
            }
        }
    }
}
