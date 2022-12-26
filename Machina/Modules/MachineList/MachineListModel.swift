//
//  MachineListModel.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 26/12/22.
//

import RealmSwift
import Foundation

// Model for saving adn get data in realm
class Machine: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String = ""
    @Persisted var type: String = ""
    @Persisted var qrCodeNumber: String = ""
    @Persisted var lastMaintenanceDate: Date = Date()
    @Persisted var imagesUrl = List<String>()
    
    convenience init(name: String, type: String, qrCodeNumber: String) {
        self.init()
        self.name = name
        self.type = type
        self.qrCodeNumber = qrCodeNumber
    }
}
