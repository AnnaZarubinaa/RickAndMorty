import Foundation

public struct LocationInfoApiRequest: APIRequest {
    typealias Response = LocationResponseModel
    
    func decodeResponse(data: Data) throws -> Response {
        let charactersInfo = try JSONDecoder().decode(Response.self, from: data)
        return charactersInfo
    }
}

struct LocationResponseModel: Codable {
    var info: InfoModel
    var results: [LocationModel]
    
    init() {
        info = InfoModel()
        results = [LocationModel]()
    }
}

struct LocationModel: Codable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
}
