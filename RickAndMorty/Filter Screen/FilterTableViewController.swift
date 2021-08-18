import UIKit

protocol FilterView {
    func selectRow(_ tableView: UITableView, indexPath: IndexPath)
    func deselectRow(_ tableView: UITableView, indexPath: IndexPath)
}

class FilterTableViewController: UITableViewController {

    @IBOutlet var resetSection1Button: UIButton!
    @IBOutlet var resetSection2Button: UIButton!
    
    let filterPresenter = FilterPresenter(model: CharacterFilter())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterPresenter.attachView(view: self)
        tableView.backgroundColor = UIColor(named: "Background")
        
        resetSection1Button.isEnabled = false

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
    
    
    @IBAction func resetSection1ButtonTapped(_ sender: Any) {
        filterPresenter.resetSection1ButtonTapped(tableView)
    }
    
    @IBAction func resetSection2ButtonTapped(_ sender: Any) {
        filterPresenter.resetSection2ButtonTapped(tableView)
    }
    
    func configureButton(button: UIButton) {
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FilterTableViewController: FilterView {
    
    func selectRow(_ tableView: UITableView, indexPath: IndexPath) {
        guard tableView.cellForRow(at: indexPath)?.reuseIdentifier != "Header" else { return }
        
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        
        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = UIColor(named: "Title")
        tableView.cellForRow(at: indexPath)?.tintColor = UIColor(named: "Title")

        tableView.cellForRow(at: indexPath)?.selectedBackgroundView?.alpha = 0.4
        
    }
    
    func deselectRow(_ tableView: UITableView, indexPath: IndexPath) {
        
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = UIColor(named: "Text")
        tableView.cellForRow(at: indexPath)?.selectedBackgroundView?.alpha = 0.4
    }
}
