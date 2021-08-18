import Foundation
import UIKit

class FilterPresenter {
    var filterView: FilterView?
    var filters: CharacterFilter
    
    init (model: CharacterFilter ) {
        self.filters = model
    }
    
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
        
    }
    
    func resetSection1ButtonTapped(_ tableView: UITableView) {
        for cell in 0 ..< tableView.numberOfRows(inSection: 0) {
            let indexPath = IndexPath(row: cell, section: 0)
            filterView?.deselectRow(tableView, indexPath: indexPath)
            removeFromModel(tableView, indexPath: indexPath)
        }
    }
    
    func resetSection2ButtonTapped(_ tableView: UITableView) {
        for cell in 0 ..< tableView.numberOfRows(inSection: 1) {
            let indexPath = IndexPath(row: cell, section: 1)
            filterView?.deselectRow(tableView, indexPath: indexPath)
            removeFromModel(tableView, indexPath: indexPath)
        }
    }
    
    func addToModel(_ tableView: UITableView, indexPath: IndexPath) {
        let celltext = tableView.cellForRow(at: indexPath)?.textLabel?.text?.lowercased()
        
        if indexPath.section == 0 {
            switch celltext {
            case Status.alive.rawValue:
                filters.status.insert(.alive)
            case Status.dead.rawValue:
                filters.status.insert(.dead)
            case Status.unknown.rawValue:
                filters.status.insert(.unknown)
            default: break
            }
        }
        
        if indexPath.section == 1 {
            switch celltext {
            case Gender.female.rawValue:
                filters.gender.insert(.female)
            case Gender.male.rawValue:
                filters.gender.insert(.male)
            case Gender.genderless.rawValue:
                filters.gender.insert(.genderless)
            case Gender.unknown.rawValue:
                filters.gender.insert(.unknown)
            default: break
            }
        }
        print(filters)
    }
    
    func removeFromModel(_ tableView: UITableView, indexPath: IndexPath) {
        let celltext = tableView.cellForRow(at: indexPath)?.textLabel?.text?.lowercased()
        
        if indexPath.section == 0 {
            switch celltext {
            case Status.alive.rawValue:
                filters.status.remove(.alive)
            case Status.dead.rawValue:
                filters.status.remove(.dead)
            case Status.unknown.rawValue:
                filters.status.remove(.unknown)
            default: break
            }
        }
        
        if indexPath.section == 1 {
            switch celltext {
            case Gender.female.rawValue:
                filters.gender.remove(.female)
            case Gender.male.rawValue:
                filters.gender.remove(.male)
            case Gender.genderless.rawValue:
                filters.gender.remove(.genderless)
            case Gender.unknown.rawValue:
                filters.gender.remove(.unknown)
            default: break
            }
        }
        print(filters)
    }
}
