//
//  DetailMachineViewController.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 27/12/22.
//

import UIKit

class DetailMachineViewController: BaseVC {
    private var viewModel: DetailMachineViewModel
    
    lazy var navigationBar: CustomNavigationBar = {
        let navbar = CustomNavigationBar(title: "Details")
        return navbar
    }()
    
    private lazy var statusBarView: UIView = {
        let view = UIView()
        view.layer.zPosition = 10
        view.backgroundColor = navigationBar.backgroundColor
        return view
    }()
    
    required init(viewModel: BaseViewModelContract) {
        self.viewModel = viewModel as! DetailMachineViewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.requestDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        [navigationBar, statusBarView].forEach { view in
            self.view.addSubview(view)
        }
        navigationBar.layoutIfNeeded()
        configureConstraints()
    }
    
    func configureConstraints() {
        navigationBar.anchor(top: statusBarView.bottomAnchor,
                             leading: view.leadingAnchor,
                             bottom: nil,
                             trailing: view.trailingAnchor,
                             size: .init(width: 0, height: 56))
        statusBarView.anchor(top: view.topAnchor,
                             leading: view.leadingAnchor,
                             bottom: nil,
                             trailing: view.trailingAnchor,
                             size: .init(width: 0, height: UIApplication.statusBarHeight))
    }
}

extension DetailMachineViewController: RequestProtocol {
    func updateState(with state: ViewState) {
        //
    }
}
