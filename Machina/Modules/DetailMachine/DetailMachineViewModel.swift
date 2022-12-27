//
//  DetailMachineViewModel.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 27/12/22.
//

import Foundation

class DetailMachineViewModel: BaseViewModelContract {
    enum UpdatedState {
        case updated
        case noUpdate
    }
    
    var state: ViewState = .idle {
        didSet {
            requestDelegate?.updateState(with: state)
        }
    }
    weak var requestDelegate: RequestProtocol?
    weak var machineListUpdateDelegate: MachineListUpdateDelegate?
    var viewData: DetailMachineModel
    
    init(viewData: DetailMachineModel, machineListUpdateDelegate: MachineListUpdateDelegate? = nil) {
        self.viewData = viewData
        self.machineListUpdateDelegate = machineListUpdateDelegate
    }
    
    func saveMachineDetail(name: String, type: String, maintenance: String, onSuccess: @escaping onSuccess) {
        // convert string to date
        let convertedDate = Date.convertStringToDate(string: maintenance)
        
        let updatedMachineDataModel = UpdatedMachineDataModel(name: name, type: type, lastMaintenanceDate: convertedDate, imagesUrl: [])
        machineListUpdateDelegate?.saveMachineDetails(indexPath: viewData.itemIndexPath,
                                                                updatedMachineModel: updatedMachineDataModel)
        state = .success(onSuccess)
    }
}
