import Foundation

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

