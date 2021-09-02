import Foundation

struct CharacterFilterModel {
    var status: Set<String>
    var gender: Set<String>
    
    init() {
        status = []
        gender = []
    }
}
