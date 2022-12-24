//
//  ViewController.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 24/12/22.
//

import UIKit

class MainViewController: UITabBarController {
    
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
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        tabBar.backgroundColor = .lightGray
        tabBar.alpha = 0.8
        viewControllers = viewModel.tabBarViewControllers
    }
}

