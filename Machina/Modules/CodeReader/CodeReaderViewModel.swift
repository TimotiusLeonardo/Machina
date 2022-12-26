//
//  CodeReaderViewModel.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 24/12/22.
//

import UIKit

class CodeReaderViewModel: BaseViewModelContract {
    weak var requestDelegate: RequestProtocol?
    var state: ViewState = .idle
    
    func createAlertView(title: String, message: String) -> UIAlertController {
        let alertView = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
        return alertView
    }
}
