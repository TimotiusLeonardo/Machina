//
//  CodeReaderViewModel.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 24/12/22.
//

import Foundation

class MachineListViewModel: BaseViewModelContract {
    weak var requestDelegate: RequestProtocol?
    var state: ViewState = .idle
    
    func updateState(with state: ViewState) {
        //
    }
    
    
}
