//
//  CodeReaderViewModel.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 24/12/22.
//

import Foundation
import RealmSwift
import UIKit

class MachineListViewModel: BaseViewModelContract {
    enum SortType {
        case name(ascending: Bool)
        case none
    }
    
    weak var requestDelegate: RequestProtocol?
    var stateDispatchQueue: DispatchQueue = .main
    var state: ViewState = .idle {
        didSet {
            stateDispatchQueue.async {
                self.requestDelegate?.updateState(with: self.state)
            }
        }
    }
    var realm = try? Realm()
    var sortMachineBy: SortType = .none
    var machines: Results<Machine>? {
        get {
            switch sortMachineBy {
            case .name(let ascending):
                return realm?.objects(Machine.self).sorted(byKeyPath: "name", ascending: ascending)
            case .none:
                return realm?.objects(Machine.self)
            }
        }
    }
    
    func createAlertView(title: String, message: String) -> UIAlertController {
        let alertView = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
        return alertView
    }
    
    func addMachine(onSuccess: @escaping onSuccess,
                    onError: @escaping onError,
                    name: String,
                    type: String
    ) {
        let machine = Machine(name: name, type: type, qrCodeNumber: "\(Int(Date().timeIntervalSince1970))")
        
        do {
            try realm?.write({
                realm?.add(machine)
                state = .success(onSuccess)
            })
        } catch {
            Log("Error add machine: \(error)")
        }
        
    }
    
    func removeMachine(at indexPath: IndexPath) {
        guard let machines = machines,
              machines.count > indexPath.row else {
            // Index out of bound
            return
        }
        
        let itemToDelete = machines[indexPath.row]
        
        do {
            try realm?.write({
                realm?.delete(itemToDelete)
            })
        } catch {
            Log("Error add machine: \(error)")
            state = .error(nil)
        }
    }
    
    func openMachineDetail(indexPath: IndexPath) -> DetailMachineViewController? {
        guard let machines = machines, machines.count > indexPath.row else {
            return nil
        }
        let machine = machines[indexPath.row]
        let imageUrl: [String] = machine.imagesUrl.map { $0 }
        let detailMachineViewData = DetailMachineModel(name: machine.name,
                                                       type: machine.type,
                                                       qrCodeNumber: machine.qrCodeNumber,
                                                       lastMaintenanceDate: machine.lastMaintenanceDate,
                                                       imageUrl: imageUrl,
                                                       itemIndexPath: indexPath)
        let detailMachineViewModel = DetailMachineViewModel(viewData: detailMachineViewData, machineListUpdateDelegate: self)
        let detailVC = DetailMachineViewController(viewModel: detailMachineViewModel)
        return detailVC
    }
}

extension MachineListViewModel: MachineListUpdateDelegate {
    func saveMachineDetails(indexPath: IndexPath, updatedMachineModel: UpdatedMachineDataModel) {
        guard let machines = machines, machines.count > indexPath.row else {
            return
        }
        state = .loading
        do {
            let itemsToUpdate = machines[indexPath.row]
            try realm?.write({
                itemsToUpdate.name = updatedMachineModel.name
                itemsToUpdate.type = updatedMachineModel.type
                itemsToUpdate.imagesUrl = updatedMachineModel.imagesUrl
                itemsToUpdate.lastMaintenanceDate = updatedMachineModel.lastMaintenanceDate
                state = .success(nil)
            })
        } catch {
            Log("Error add machine: \(error)")
            state = .error(nil)
        }
    }
}
