import Foundation
import UIKit

class CharacterDetailsPresener {
    
    var character: CharacterModel
    var characterImage = UIImage()
    
    weak var characterDetailsView: CharacterDetailsView?
    
    init (model: CharacterModel) {
        self.character = model
    }
    
    func attachView(view: CharacterDetailsView?) {
        self.characterDetailsView = view
    }
    
    func updateUI() {
        characterDetailsView?.updateUI(with: character)
        characterDetailsView?.updateUI(with: characterImage)
        
    }
}
