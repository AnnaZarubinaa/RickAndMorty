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
    
    override func viewDidAppear(_ animated: Bool) {
        filterPresenter.resumeSelectedRowState(tableView: tableView)
        refreshResetStatusButton()
        refreshResetGenderButton()
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row == 0 {
            return nil
        }
        
        for vcip in tableView.indexPathsForSelectedRows ?? [] {
            if vcip.section == indexPath.section && vcip.item != indexPath.item {
                return nil
            }
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
        //filterPresenter.saveSelectedRowsState(tableView: tableView)
        animateResetButton(button: applyFiltersButton)
        print("tapped")
        navigationController?.popViewController(animated: true)
    }
    
    func configureButtons() {
        
        resetStatusButton.setTitleColor(UIColor(named: "Red"), for: .normal)
        resetStatusButton.setTitleColor(UIColor(named: "Grey"), for: .disabled)
        
        resetGenderButton.setTitleColor(UIColor(named: "Red"), for: .normal)
        resetGenderButton.setTitleColor(UIColor(named: "Grey"), for: .disabled)
        
        refreshResetStatusButton()
        refreshResetGenderButton()
        
        
//        applyFiltersButton.backgroundColor = UIColor(named: "White")
//        applyFiltersButton.layer.borderColor = UIColor(named: "Title")?.cgColor
//        applyFiltersButton.layer.cornerRadius = 4.0
        
    }
    
}

extension FilterTableViewController: FilterView {
    
    func selectRow(_ tableView: UITableView, indexPath: IndexPath) {
        guard tableView.cellForRow(at: indexPath)?.reuseIdentifier != "Header" else { return }
        
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        
        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = UIColor(named: "Title")
        tableView.cellForRow(at: indexPath)?.tintColor = UIColor(named: "Title")
        tableView.cellForRow(at: indexPath)?.backgroundView?.backgroundColor = .none
        tableView.cellForRow(at: indexPath)?.selectionStyle = .none
        refreshResetStatusButton()
        
    }
    
    func deselectRow(_ tableView: UITableView, indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = UIColor(named: "Text")
        tableView.cellForRow(at: indexPath)?.selectionStyle = .none
    
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
