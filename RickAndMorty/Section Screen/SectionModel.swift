import Foundation

protocol APIRequest {
    associatedtype Response

    func decodeResponse(data: Data) throws -> Response
}

struct SectionModel {
    
    let sectionsName = ["Characters", "Locations", "Episodes"]
    let sectionsImages = ["sectionCharacters", "sectionLocations", "sectionEpisodes"]
}

struct SectionURL: Codable {
    
    static var shared = SectionURL()
    
    var episodes: String
    var locations: String
    var characters: String
    
    private init() {
        episodes = ""
        locations = ""
        characters = ""
    }
}



public struct SectionInfoApiRequest: APIRequest {
    typealias Response = SectionURL
    
    func decodeResponse(data: Data) throws -> Response {
        let sectionInfo = try JSONDecoder().decode(Response.self, from: data)
        return sectionInfo
    }
}

