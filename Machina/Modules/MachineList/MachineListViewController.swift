//
//  CodeReaderViewController.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 24/12/22.
//

import UIKit

class MachineListViewController: BaseVC {
    private var viewModel: MachineListViewModel
    
    lazy var navigationBar = CustomNavigationBar(text: "Machines")
    
    required init(viewModel: BaseViewModelContract) {
        self.viewModel = viewModel as! MachineListViewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.requestDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .blue
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

extension MachineListViewController: RequestProtocol {
    func updateState(with state: ViewState) {
        //
    }
}
