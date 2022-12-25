//
//  ViewState.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 25/12/22.
//

import Foundation

enum ViewState {
    case idle
    case loading
    case success
    case error(Error)
}
