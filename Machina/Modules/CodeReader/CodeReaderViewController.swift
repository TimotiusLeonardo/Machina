//
//  CodeReaderViewController.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 24/12/22.
//

import UIKit

class CodeReaderViewController: BaseVC {
    private var viewModel: CodeReaderViewModel
    
    lazy var navigationBar = CustomNavigationBar(text: "Code Reader")
    
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
        createViews()
    }
    
    func createViews() {
        [navigationBar].forEach { view in
            self.view.addSubview(view)
        }
        configureConstraints()
    }
    
    func configureConstraints() {
        navigationBar.anchor(top: view.topAnchor,
                             leading: view.leadingAnchor,
                             bottom: nil,
                             trailing: view.trailingAnchor)
    }
}

extension CodeReaderViewController: RequestProtocol {
    func updateState(with state: ViewState) {
        //
    }
}
