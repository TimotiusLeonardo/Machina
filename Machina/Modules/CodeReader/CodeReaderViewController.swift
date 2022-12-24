//
//  CodeReaderViewController.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 24/12/22.
//

import UIKit

class CodeReaderViewController: UIViewController {
    private var viewModel: CodeReaderViewModel
    
    init(viewModel: CodeReaderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
