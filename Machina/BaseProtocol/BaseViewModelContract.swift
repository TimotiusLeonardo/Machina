//
//  BaseViewModelContract.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 25/12/22.
//

import Foundation

protocol RequestProtocol: AnyObject {
    func updateState(with state: ViewState)
}

protocol BaseViewModelContract {
    var requestDelegate: RequestProtocol? { get set }
    var state: ViewState { get set }
}
