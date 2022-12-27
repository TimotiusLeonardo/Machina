//
//  CodeReaderViewController.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 24/12/22.
//

import UIKit

class MachineListViewController: BaseVC {
    private var viewModel: MachineListViewModel
    
    lazy var navigationBar: CustomNavigationBar = {
        let navbar = CustomNavigationBar(title: "Machines")
        navbar.configureToolbar([addButton, sortButton])
        return navbar
    }()
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.register(MachineListCell.self, forCellReuseIdentifier: MachineListCell.identifier)
        return tableView
    }()
    private lazy var statusBarView: UIView = {
        let view = UIView()
        view.layer.zPosition = 10
        view.backgroundColor = navigationBar.backgroundColor
        return view
    }()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        button.addTarget(self, action: #selector(onSortButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(onAddButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var nameInputTextField: UITextField?
    private var typeInputTextField: UITextField?
    
    required init(viewModel: BaseViewModelContract) {
        self.viewModel = viewModel as! MachineListViewModel
        super.init(nibName: nil, bundle: nil)
        self.viewModel.requestDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        createViews()
        viewModel.getMachinesData { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func createViews() {
        [navigationBar, statusBarView, tableView].forEach { view in
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
        tableView.anchor(top: navigationBar.bottomAnchor,
                         leading: view.leadingAnchor,
                         bottom: view.bottomAnchor,
                         trailing: view.trailingAnchor)
        sortButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    func giveBlankTextfieldWarning() {
        let alertView = viewModel.createAlertView(title: "Blank Field",
                                                  message: "There are one or more blank field, please fill complete it first")
        alertView.addAction(.init(title: "OK", style: .default, handler: { _ in
            alertView.dismiss(animated: true) {
                self.onAddButtonTapped()
            }
        }))
        
        present(alertView, animated: true)
    }
}

// MARK: - OBJC functions
extension MachineListViewController {
    @objc func onSortButtonTapped() {
        Log("Sort button tapped")
    }
    
    @objc func onAddButtonTapped() {
        let alertView = viewModel.createAlertView(title: "Add Your Machine", message: "Please fill in the blanks to add your machine")
        alertView.addTextField { [weak self] textField in
            self?.nameInputTextField = textField
            textField.placeholder = "Name"
        }
        
        alertView.addTextField { [weak self] textfield in
            self?.typeInputTextField = textfield
            textfield.placeholder = "Type"
        }
        
        alertView.addAction(UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: { [weak self] _ in
            guard let name = self?.nameInputTextField?.text,
                  let type = self?.typeInputTextField?.text else {
                // If one or two textfield is blank, dismiss the alertview and show warning alertview
                alertView.dismiss(animated: true) {
                    self?.giveBlankTextfieldWarning()
                }
                return
            }
            
            self?.viewModel.addMachine(onSuccess: {
                self?.tableView.reloadData()
            }, onError: {
                // Nothing to do
            }, name: name, type: type)
            self?.nameInputTextField?.text = nil
            self?.typeInputTextField?.text = nil
        }))
        
        alertView.addAction(UIAlertAction(title: "Cancel",
                                          style: .cancel,
                                          handler: { _ in
            alertView.dismiss(animated: true)
        }))
        
        present(alertView, animated: true)
    }
}

extension MachineListViewController: RequestProtocol {
    func updateState(with state: ViewState) {
        switch state {
        case .idle:
            Log("Nothing to do")
        case .loading:
            Log("Nothing to do")
        case .success(let onSuccess):
            onSuccess?()
        case .error(let onError):
            onError?()
        }
    }
}

extension MachineListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.machines?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let machineListCell = tableView.dequeueReusableCell(withIdentifier: MachineListCell.identifier, for: indexPath) as? MachineListCell else {
            return UITableViewCell()
        }
        machineListCell.setupCells(data: viewModel.machines?[indexPath.row])
        return machineListCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeMachine(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
