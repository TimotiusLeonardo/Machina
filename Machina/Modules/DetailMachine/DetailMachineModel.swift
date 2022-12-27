//
//  DetailMachineModel.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 27/12/22.
//

import Foundation

struct DetailMachineModel {
    var name: String
    var type: String
    var qrCodeNumber: String
    var lastMaintenanceDate: String
    var imageUrl: [String]
    
    init(machine: Machine) {
        self.name = machine.name
        self.type = machine.type
        self.qrCodeNumber = machine.qrCodeNumber
        self.lastMaintenanceDate = machine.lastMaintenanceDate.convertToStringFormat()
        self.imageUrl = machine.imagesUrl.map({ $0 })
    }
}
