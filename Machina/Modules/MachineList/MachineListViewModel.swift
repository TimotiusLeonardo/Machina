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
        }
    }
}
