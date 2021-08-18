import Foundation

struct CharacterFilter {
    var status: Set<Status>
    var gender: Set<Gender>
    
    init() {
        status = []
        gender = []
    }
}

enum Status: String {
    case alive = "alive"
    case dead = "dead"
    case unknown = "unknown"
    case none = ""
}

enum Gender: String {
    case female = "female"
    case male = "male"
    case genderless = "genderless"
    case unknown = "unknown"
    case none = ""
}
