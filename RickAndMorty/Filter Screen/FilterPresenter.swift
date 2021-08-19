import Foundation
import UIKit

class FilterPresenter {
    
    weak var filterView: FilterView?
    weak var delegate: FilterDataDelegate?
    
    var statusFilters = Set<String>()
    var genderFilters = Set<String>()
    
    
    func attachView(view: FilterView?) {
        self.filterView = view
    }
    
    func didSelectRow(_ tableView: UITableView, indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.none {
            self.filterView?.selectRow(tableView, indexPath: indexPath)
            addToModel(tableView, indexPath: indexPath)
            
        } else {
            self.filterView?.deselectRow(tableView, indexPath: indexPath)
            removeFromModel(tableView, indexPath: indexPath)
        }
        self.filterView?.refreshResetStatusButton()
        self.filterView?.refreshResetGenderButton()
        
    }
    
    func getStatusFilterElementsCount() -> Int {
        return statusFilters.count
    }
    
    func getGenderFilterElementsCount() -> Int {
        return genderFilters.count
    }
    
    func resetStatusButtonTapped(_ tableView: UITableView) {
        for cell in 0 ..< tableView.numberOfRows(inSection: 0) {
            let indexPath = IndexPath(row: cell, section: 0)
            filterView?.deselectRow(tableView, indexPath: indexPath)
            removeFromModel(tableView, indexPath: indexPath)
        }
        self.filterView?.refreshResetStatusButton()
    }
    
    func resetGenderButtonTapped(_ tableView: UITableView) {
        for cell in 0 ..< tableView.numberOfRows(inSection: 1) {
            let indexPath = IndexPath(row: cell, section: 1)
            filterView?.deselectRow(tableView, indexPath: indexPath)
            removeFromModel(tableView, indexPath: indexPath)
        }
        self.filterView?.refreshResetGenderButton()
    }
    
    func applyFilersButtonTapped() {
        delegate?.updateFilterData(status: statusFilters, gender: genderFilters)
    }
    
    func addToModel(_ tableView: UITableView, indexPath: IndexPath) {
        let celltext = tableView.cellForRow(at: indexPath)?.textLabel?.text?.lowercased()
        
        if indexPath.section == 0 {
            statusFilters.insert(celltext ?? " ")
        }
        
        if indexPath.section == 1 {
            genderFilters.insert(celltext ?? " ")
        }
        
        print(statusFilters)
        print(genderFilters)
    }
    
    func removeFromModel(_ tableView: UITableView, indexPath: IndexPath) {
        let celltext = tableView.cellForRow(at: indexPath)?.textLabel?.text?.lowercased()
        
        if indexPath.section == 0 {
            statusFilters.remove(celltext ?? " ")
        }
        
        if indexPath.section == 1 {
            genderFilters.remove(celltext ?? " ")
        }
        
        print(statusFilters)
        print(genderFilters)
    }
    
}
