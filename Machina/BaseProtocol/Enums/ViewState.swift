//
//  ViewState.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 25/12/22.
//

import Foundation

typealias onSuccess = (() -> Void)
typealias onError = (() -> Void)

enum ViewState {
    case idle
    case loading
    case success(onSuccess?)
    case error(onError?)
}
