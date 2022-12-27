//
//  DetailMachineViewModel.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 27/12/22.
//

import Foundation
import RealmSwift
import Photos
import UIKit

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
        
        // We will use save method from this module.
        do {
            try realm?.write({
                machine?.name = name
                machine?.type = type
                for image in viewData.images {
                    machine?.images.append(image as Data)
                }
                machine?.lastMaintenanceDate = convertedDate
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
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            var thumbnail = UIImage()
            option.isSynchronous = true
            manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: option, resultHandler: {(result, info) -> Void in
                thumbnail = result!
                guard let pngData = UIImage.pngData(thumbnail)() else { return }
                let dataPNGImg = NSData(data: pngData)
                self.viewData.images.append(dataPNGImg)
                self.selectedStringDispatchGroup.leave()
            })
        }
        
        selectedStringDispatchGroup.notify(queue: .main) {
            self.state = .success(onSuccess)
        }
    }
}
