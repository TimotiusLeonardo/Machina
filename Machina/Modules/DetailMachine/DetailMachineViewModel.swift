//
//  DetailMachineViewModel.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 27/12/22.
//

import Foundation
import RealmSwift
import Photos

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
    var selectedStringDispatchGroup: DispatchGroup = DispatchGroup()
    var viewData: DetailMachineModel
    var machine: Machine?
    lazy var realm = try? Realm()
    
    init(machine: Machine, machineListUpdateDelegate: MachineListUpdateDelegate? = nil) {
        self.viewData = DetailMachineModel(machine: machine)
        self.machineListUpdateDelegate = machineListUpdateDelegate
        self.machine = machine
    }
    
    func saveMachineDetail(name: String, type: String, maintenance: String, onSuccess: @escaping onSuccess) {
        // convert string to date
        let convertedDate = Date.convertStringToDate(string: maintenance)
        
        let updatedMachineDataModel = UpdatedMachineDataModel(name: name, type: type, lastMaintenanceDate: convertedDate, imagesUrl: viewData.imageUrl)
        
        // We will use save method from this module.
        do {
            try realm?.write({
                machine?.name = updatedMachineDataModel.name
                machine?.type = updatedMachineDataModel.type
                machine?.imagesUrl = updatedMachineDataModel.imagesUrl
                machine?.lastMaintenanceDate = updatedMachineDataModel.lastMaintenanceDate
                machineListUpdateDelegate?.saveMachineDetails()
                state = .success(onSuccess)
            })
        } catch {
            Log("Error add machine: \(error)")
            state = .error(nil)
        }
    }
    
    func saveSelectedImageUrl(assets: [PHAsset], onSuccess: @escaping onSuccess) {
        for asset in assets {
            selectedStringDispatchGroup.enter()
            getImageUrlFrom(asset) { url in
                self.viewData.imageUrl.append(url)
                self.selectedStringDispatchGroup.leave()
            }
        }
        
        selectedStringDispatchGroup.notify(queue: .main) {
            self.state = .success(onSuccess)
        }
    }
    
    private func getImageUrlFrom(_ asset: PHAsset, onSuccess: @escaping (String) -> Void) {
        asset.requestContentEditingInput(with: PHContentEditingInputRequestOptions()) { (editingInput, info) in
            if let input = editingInput, let imgURL = input.fullSizeImageURL {
                onSuccess(imgURL.absoluteString)
            }
        }
    }
}
