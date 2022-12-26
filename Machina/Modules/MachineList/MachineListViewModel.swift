//
//  CodeReaderViewModel.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 24/12/22.
//

import Foundation
import RealmSwift

class MachineListViewModel: BaseViewModelContract {
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
    var machines: Results<Machine>?
    
    func getMachinesData(onSuccess: @escaping onSuccess) {
        let machines = realm?.objects(Machine.self)
        self.machines = machines
        state = .success(onSuccess)
    }
    
    func addMachine(onSuccess: @escaping onSuccess, onError: @escaping onError) {
        let machine = Machine(name: "Timotius", type: "Otomotif", qrCodeNumber: "12345")
        
        do {
            try realm?.write({
                realm?.add(machine)
                state = .success(onSuccess)
            })
        } catch {
            Log("Error add machine: \(error)")
        }
        
    }
}
