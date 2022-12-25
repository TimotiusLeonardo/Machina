//
//  CodeReaderViewController.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 24/12/22.
//

import UIKit

class CodeReaderViewController: BaseVC {
    private var viewModel: CodeReaderViewModel
    
    required init(viewModel: BaseViewModelContract) {
        self.viewModel = viewModel as! CodeReaderViewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.requestDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .red
        navigationController?.title = "Code Reader"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

extension CodeReaderViewController: RequestProtocol {
    func updateState(with state: ViewState) {
        //
    }
}
