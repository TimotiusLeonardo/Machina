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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .heavy)
        label.textColor = .black
        return label
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.addTarget(self, action: #selector(onEditButtonTapped), for: .touchUpInside)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private var machineTypeSection: DetailListView
    private var machineQrCodeNumberSection: DetailListView
    private var machineLastMaintenanceSection: DetailListView
    
    required init(viewModel: BaseViewModelContract) {
        self.viewModel = viewModel as! DetailMachineViewModel
        machineTypeSection = DetailListView(title: "Type",
                                            description: self.viewModel.viewData.type)
        machineQrCodeNumberSection = DetailListView(title: "QR Number",
                                             description: self.viewModel.viewData.qrCodeNumber)
        machineLastMaintenanceSection = DetailListView(title: "Last Maintanance",
                                                       description: self.viewModel.viewData.lastMaintenanceDate)
        super.init(nibName: nil, bundle: nil)
        self.viewModel.requestDelegate = self
        titleLabel.text = self.viewModel.viewData.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        [navigationBar, statusBarView, titleLabel, dividerView, machineTypeSection, machineQrCodeNumberSection, machineLastMaintenanceSection].forEach { view in
            self.view.addSubview(view)
        }
        navigationBar.configureToolbar([editButton])
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
        titleLabel.anchor(top: navigationBar.bottomAnchor,
                          leading: view.leadingAnchor,
                          bottom: nil,
                          trailing: view.trailingAnchor,
                          padding: .init(top: 32,
                                         left: 24,
                                         bottom: 0,
                                         right: 24),
                          size: .init(width: 0, height: 0))
        dividerView.anchor(top: titleLabel.bottomAnchor,
                           leading: view.leadingAnchor,
                           bottom: nil,
                           trailing: view.trailingAnchor,
                           padding: .init(top: 4, left: 0, bottom: 0, right: 0),
                           size: .init(width: 0, height: 2))
        machineTypeSection.anchor(top: dividerView.bottomAnchor,
                                  leading: view.leadingAnchor,
                                  bottom: nil,
                                  trailing: view.trailingAnchor,
                                  padding: .init(top: 32, left: 24, bottom: 0, right: 24))
        machineTypeSection.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        machineQrCodeNumberSection.anchor(top: machineTypeSection.bottomAnchor,
                                  leading: machineTypeSection.leadingAnchor,
                                  bottom: nil,
                                  trailing: machineTypeSection.trailingAnchor,
                                  padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        machineQrCodeNumberSection.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        machineLastMaintenanceSection.anchor(top: machineQrCodeNumberSection.bottomAnchor,
                                          leading: machineQrCodeNumberSection.leadingAnchor,
                                          bottom: nil,
                                          trailing: machineQrCodeNumberSection.trailingAnchor,
                                          padding: .init(top: 8, left: 0, bottom: 0, right: 0))
        machineLastMaintenanceSection.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        
    }
}

// MARK: - OBJC functions
extension DetailMachineViewController {
    @objc func onEditButtonTapped() {
        Log("on button tapped")
    }
}

extension DetailMachineViewController: RequestProtocol {
    func updateState(with state: ViewState) {
        //
    }
}
