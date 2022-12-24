//
//  ViewController.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 24/12/22.
//

import UIKit

class MainViewController: UIViewController {
    
    private let viewModel: MainViewModel
    
    required init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
    }
}

