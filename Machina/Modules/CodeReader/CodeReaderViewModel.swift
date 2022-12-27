//
//  CodeReaderViewModel.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 24/12/22.
//

import UIKit
import RealmSwift

class CodeReaderViewModel: BaseViewModelContract {
    weak var requestDelegate: RequestProtocol?
    let stateDispatchQueue: DispatchQueue = .main
    var state: ViewState = .idle {
        didSet {
            stateDispatchQueue.async {
                self.requestDelegate?.updateState(with: self.state)
            }
        }
    }
    let realm = try? Realm()
    var selectedMachine: Machine?
    
    lazy var machines = realm?.objects(Machine.self)
    
    func createAlertView(title: String, message: String) -> UIAlertController {
        let alertView = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
        return alertView
    }
    
    func checkCodeAvailability(_ code: String, onSuccess: @escaping onSuccess, onError: @escaping onError) {
        // If qr value is available, go to detail page
        guard let machines = machines else { return }
        for machine in machines where machine.qrCodeNumber == code {
            state = .success(onSuccess)
            selectedMachine = machine
            return
        }
        
        state = .error(onError)
    }
    
    func createDetailViewController() -> DetailMachineViewController? {
        guard let selectedMachine = selectedMachine else { return nil }
        let viewModel = DetailMachineViewModel(machine: selectedMachine)
        let viewController = DetailMachineViewController(viewModel: viewModel)
        return viewController
    }
}
