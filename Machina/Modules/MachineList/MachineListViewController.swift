//
//  CodeReaderViewController.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 24/12/22.
//

import UIKit

class MachineListViewController: UIViewController {
    private var viewModel: MachineListViewModel
    
    init(viewModel: MachineListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .blue
        navigationController?.title = "Machines"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
