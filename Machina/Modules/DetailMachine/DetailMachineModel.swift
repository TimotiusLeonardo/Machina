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
    var itemIndexPath: IndexPath
    
    init(name: String, type: String, qrCodeNumber: String, lastMaintenanceDate: Date, imageUrl: [String], itemIndexPath: IndexPath) {
        self.name = name
        self.type = type
        self.qrCodeNumber = qrCodeNumber
        self.lastMaintenanceDate = lastMaintenanceDate.convertToStringFormat()
        self.imageUrl = imageUrl
        self.itemIndexPath = itemIndexPath
    }
}
