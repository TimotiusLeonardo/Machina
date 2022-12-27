//
//  DetailMachineViewModel.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 27/12/22.
//

import Foundation

class DetailMachineViewModel: BaseViewModelContract {
    var state: ViewState = .idle {
        didSet {
            requestDelegate?.updateState(with: state)
        }
    }
    weak var requestDelegate: RequestProtocol?
    var viewData: DetailMachineModel
    
    init(viewData: DetailMachineModel) {
        self.viewData = viewData
    }
}
