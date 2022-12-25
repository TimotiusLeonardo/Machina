//
//  CodeReaderViewModel.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 24/12/22.
//

import Foundation

class CodeReaderViewModel: BaseViewModelContract {
    var requestDelegate: RequestProtocol?
    weak var delegate: BaseViewModelContract?
    var state: ViewState = .idle
    
    func updateState(with state: ViewState) {
        //
    }
    
    
}
