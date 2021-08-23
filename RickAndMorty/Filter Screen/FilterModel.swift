import Foundation

struct CharacterFilterModel {
    var status: Set<String>
    var gender: Set<String>
    
    init() {
        status = []
        gender = []
    }
}

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
    
}
