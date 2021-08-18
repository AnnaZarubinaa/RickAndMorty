import Foundation

public struct CharacterInfoApiRequest: APIRequest {
    typealias Response = CharacterResponseModel
    
    func decodeResponse(data: Data) throws -> Response {
        let charactersInfo = try JSONDecoder().decode(Response.self, from: data)
        return charactersInfo
    }
}

struct CharacterResponseModel: Codable {
    var info: InfoModel
    var results = [CharacterModel]()
    
    init() {
        info = InfoModel()
    }
}

extension CharacterResponseModel {
    func clear() -> CharacterResponseModel{
        return CharacterResponseModel()
    }
}

struct InfoModel: Codable {
    var count: Int
    var pages: Int
    var next: String?
    var prev: String?
    
    init() {
        count = 0
        pages = 0
        next = ""
        prev = ""
    }
    
}
struct CharacterModel: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: CharacterOriginModel
    let location: CharacterLocationModel
    let image: String
    let episode: [String]
    let url: String
    let created: String
    
    init() {
        id = 0
        name = ""
        status = ""
        species = ""
        type = ""
        gender = ""
        origin = CharacterOriginModel(name: "", url: "")
        location = CharacterLocationModel(name: "", url: "")
        image = ""
        episode = [""]
        url = ""
        created = ""
    }
}

struct CharacterOriginModel: Codable {
    let name: String
    let url: String
}

struct CharacterLocationModel: Codable {
    let name: String
    let url: String
}
