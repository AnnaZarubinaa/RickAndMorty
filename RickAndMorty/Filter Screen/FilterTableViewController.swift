import UIKit

protocol FilterView: AnyObject {
    func selectRow(_ tableView: UITableView, indexPath: IndexPath)
    func deselectRow(_ tableView: UITableView, indexPath: IndexPath)
    func refreshResetStatusButton()
    func refreshResetGenderButton()
    func animateResetButton(button: UIButton)
}

class FilterTableViewController: UITableViewController {

    @IBOutlet var resetStatusButton: UIButton!
    @IBOutlet var resetGenderButton: UIButton!
    @IBOutlet var applyFiltersButton: UIButton!
    
    let filterPresenter = FilterPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterPresenter.attachView(view: self)
        tableView.backgroundColor = UIColor(named: "Background")
        
        configureButtons()
        
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row == 0 {
            return nil
        }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        filterPresenter.didSelectRow(tableView, indexPath: indexPath)
    }
    
    @IBAction func resetStatusButtonTapped(_ sender: Any) {
        filterPresenter.resetStatusButtonTapped(tableView)
        animateResetButton(button: resetStatusButton)
    }
    
    @IBAction func resetGenderButtonTapped(_ sender: Any) {
        filterPresenter.resetGenderButtonTapped(tableView)
        animateResetButton(button: resetGenderButton)
    }
    
    @IBAction func applyFilersButtonTapped(_ sender: Any) {
        filterPresenter.applyFilersButtonTapped()
        animateResetButton(button: applyFiltersButton)
        print("tapped")
    }
    
    func configureButtons() {
        resetStatusButton.isEnabled = false
        resetGenderButton.isEnabled = false
        
        resetStatusButton.setTitleColor(UIColor(named: "Red"), for: .normal)
        resetStatusButton.setTitleColor(UIColor(named: "Grey"), for: .disabled)
        
        resetGenderButton.setTitleColor(UIColor(named: "Red"), for: .normal)
        resetGenderButton.setTitleColor(UIColor(named: "Grey"), for: .disabled)
        
    }
    // MARK: - Table view data source

    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let headerCell = tableView.dequeueReusableCell(withIdentifier: "Header", for: indexPath) as! FilterTableViewCell
//
//        headerCell.selectionStyle = .none
//        configureCell(tableView, indexPath: indexPath)
//        return headerCell
//    }
//

}

extension FilterTableViewController: FilterView {
    
    func selectRow(_ tableView: UITableView, indexPath: IndexPath) {
        guard tableView.cellForRow(at: indexPath)?.reuseIdentifier != "Header" else { return }
        
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        
        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = UIColor(named: "Title")
        tableView.cellForRow(at: indexPath)?.tintColor = UIColor(named: "Title")

        tableView.cellForRow(at: indexPath)?.selectedBackgroundView?.alpha = 0.4
        
        refreshResetStatusButton()
        
    }
    
    func deselectRow(_ tableView: UITableView, indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = UIColor(named: "Text")
        tableView.cellForRow(at: indexPath)?.selectedBackgroundView?.alpha = 0.4
    
    }
    
    func refreshResetStatusButton() {
        if filterPresenter.getStatusFilterElementsCount() == 0 {
            resetStatusButton.isEnabled = false
            resetStatusButton.titleLabel?.font = UIFont.systemFont(ofSize: 21)
        } else {
            
            resetStatusButton.isEnabled = true
            resetStatusButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 21)
            
        }
    }
    
    func refreshResetGenderButton() {
        
        if filterPresenter.getGenderFilterElementsCount() == 0 {
            resetGenderButton.isEnabled = false
            resetGenderButton.titleLabel?.font = UIFont.systemFont(ofSize: 21)
        } else {
            resetGenderButton.isEnabled = true
            resetGenderButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 21)
        }
    }
    
    func animateResetButton(button: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.1, options: [], animations: {
            button.transform = CGAffineTransform(scaleX: 1.2, y: 1.1)
        }) { (_) in
            UIView.animate(withDuration: 0.1, animations: {
                button.transform = CGAffineTransform.identity
            })
        }
    }
 }
