import Foundation
import UIKit

class FilterPresenter {
    
    weak var filterView: FilterView?
    weak var delegate: FilterDataDelegate?
    
    var statusFilters = Set<String>()
    var genderFilters = Set<String>()
    var savedCellsIndexPaths  = Set<IndexPath>()
    
    func attachView(view: FilterView?) {
        self.filterView = view
    }
    
    func didSelectRow(_ tableView: UITableView, indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.none {
            self.filterView?.selectRow(tableView, indexPath: indexPath)
            addToModel(tableView, indexPath: indexPath)
            print("add index path: \(indexPath)")
            savedCellsIndexPaths.insert(indexPath)
            
        } else {
            self.filterView?.deselectRow(tableView, indexPath: indexPath)
            removeFromModel(tableView, indexPath: indexPath)
            print("remove index path: \(indexPath)")
            savedCellsIndexPaths.remove(indexPath)
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
        delegate?.updateFilterData(status: statusFilters, gender: genderFilters, cellsIndexPaths: savedCellsIndexPaths)
    }
    
    func addToModel(_ tableView: UITableView, indexPath: IndexPath) {
        let celltext = tableView.cellForRow(at: indexPath)?.textLabel?.text?.lowercased()
        
        if indexPath.section == 0 {
            statusFilters.insert(celltext ?? " ")
        }
        
        if indexPath.section == 1 {
            genderFilters.insert(celltext ?? " ")
        }
    }
    
    func removeFromModel(_ tableView: UITableView, indexPath: IndexPath) {
        let celltext = tableView.cellForRow(at: indexPath)?.textLabel?.text?.lowercased()
        
        if indexPath.section == 0 {
            statusFilters.remove(celltext ?? " ")
        }
        
        if indexPath.section == 1 {
            genderFilters.remove(celltext ?? " ")
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
        print("save state: \(savedCellsIndexPaths)")
    }
    
    func resumeSelectedRowState(tableView: UITableView) {
        print("resume state start: \(savedCellsIndexPaths)")
        for indexPath in savedCellsIndexPaths {
            print("index: \(indexPath)")
            filterView?.selectRow(tableView, indexPath: indexPath)
        }
        print("resume state finish: \(savedCellsIndexPaths)")
    }
}
