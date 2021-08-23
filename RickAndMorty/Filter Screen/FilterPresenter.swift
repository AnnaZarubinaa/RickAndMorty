import Foundation
import UIKit

class FilterPresenter {
    
    weak var filterView: FilterView?
    weak var delegate: FilterDataDelegate?
    
    var filters = CharacterFilterModel()
    
    var savedCellsIndexPaths  = Set<IndexPath>()
    
    func attachView(view: FilterView?) {
        self.filterView = view
    }
    
    func didSelectRow(_ tableView: UITableView, indexPath: IndexPath) {
        if indexPath.section == 0 && tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.none {
            
        }
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.none {
            self.filterView?.selectRow(tableView, indexPath: indexPath)
            addToModel(tableView, indexPath: indexPath)
            savedCellsIndexPaths.insert(indexPath)
            
        } else {
            self.filterView?.deselectRow(tableView, indexPath: indexPath)
            removeFromModel(tableView, indexPath: indexPath)
            savedCellsIndexPaths.remove(indexPath)
        }
        
        self.filterView?.refreshResetStatusButton()
        self.filterView?.refreshResetGenderButton()
        
    }
    
    func getStatusFilterElementsCount() -> Int {
        return filters.status.count
    }
    
    func getGenderFilterElementsCount() -> Int {
        return filters.gender.count
    }
    
    func resetStatusButtonTapped(_ tableView: UITableView) {
        for cell in 0 ..< tableView.numberOfRows(inSection: 0) {
            let indexPath = IndexPath(row: cell, section: 0)
            filterView?.deselectRow(tableView, indexPath: indexPath)
            removeFromModel(tableView, indexPath: indexPath)
            savedCellsIndexPaths.remove(indexPath)
        }
        self.filterView?.refreshResetStatusButton()
    }
    
    func resetGenderButtonTapped(_ tableView: UITableView) {
        for cell in 0 ..< tableView.numberOfRows(inSection: 1) {
            let indexPath = IndexPath(row: cell, section: 1)
            filterView?.deselectRow(tableView, indexPath: indexPath)
            removeFromModel(tableView, indexPath: indexPath)
            savedCellsIndexPaths.remove(indexPath)
        }
        self.filterView?.refreshResetGenderButton()
    }
    
    func applyFilersButtonTapped() {
        delegate?.updateFilterData(status: filters.status, gender: filters.gender, cellsIndexPaths: savedCellsIndexPaths)
    }
    
    func addToModel(_ tableView: UITableView, indexPath: IndexPath) {
        let celltext = tableView.cellForRow(at: indexPath)?.textLabel?.text?.lowercased()
        
        if indexPath.section == 0 {
            filters.status.insert(celltext ?? " ")
        }
        
        if indexPath.section == 1 {
            filters.gender.insert(celltext ?? " ")
        }
    }
    
    func removeFromModel(_ tableView: UITableView, indexPath: IndexPath) {
        let celltext = tableView.cellForRow(at: indexPath)?.textLabel?.text?.lowercased()
        
        if indexPath.section == 0 {
            filters.status.remove(celltext ?? " ")
        }
        
        if indexPath.section == 1 {
            filters.gender.remove(celltext ?? " ")
        }
    }
    
    func saveSelectedRowsState(tableView: UITableView){
        for section in 0 ..< tableView.numberOfSections {
            for cell in 0 ..< tableView.numberOfRows(inSection: section) {
                let indexPath = IndexPath(row: cell, section: section)
                let currentCell = tableView.cellForRow(at: indexPath)
                
                if currentCell?.accessoryType ==  UITableViewCell.AccessoryType.checkmark {
                    savedCellsIndexPaths.insert(indexPath)
                }
            }
        }
    }
    
    func resumeSelectedRowState(tableView: UITableView) {
        for indexPath in savedCellsIndexPaths {
            filterView?.selectRow(tableView, indexPath: indexPath)
        }
    }

}
