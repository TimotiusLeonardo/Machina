//
//  Constants.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 26/12/22.
//

import Foundation

func Log(_ message: Any) {
    #if DEBUG
    print("Log \(Date()): \(message)")
    #endif
}
