import UIKit

protocol CharacterDetailsView: AnyObject {
    func updateUI(with image: UIImage)
    func updateUI(with character: CharacterModel)
}

class CharacterDetailsViewController: UIViewController {

    @IBOutlet var CharacterImageView: UIImageView!
    
    @IBOutlet var characterNameLabel: UILabel!
    @IBOutlet var characterStatusLabel: UILabel!
    @IBOutlet var characterSpeciesLabel: UILabel!
    @IBOutlet var characterGenderLabel: UILabel!
    @IBOutlet var characterOriginLabel: UILabel!
    @IBOutlet var characterLocationLabel: UILabel!
    
    var characterDetailsPresenter = CharacterDetailsPresener(model: CharacterModel())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CharacterImageView.layer.cornerRadius = 18
        
        characterDetailsPresenter.attachView(view: self)
        characterDetailsPresenter.updateUI()
    }

}

extension CharacterDetailsViewController: CharacterDetailsView {
    func updateUI(with image: UIImage) {
        CharacterImageView.image = image
    }
    
    func updateUI(with character: CharacterModel) {
        navigationItem.title = character.name
        characterNameLabel.text = character.name
        characterStatusLabel.text = character.status
        characterSpeciesLabel.text = character.species
        characterGenderLabel.text = character.gender
        characterOriginLabel.text = character.origin.name
        characterLocationLabel.text = character.location.name
    }
}
