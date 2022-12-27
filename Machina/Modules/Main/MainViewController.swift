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
        self.viewModel.requestDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .white
        tabBar.backgroundColor = .lightGray
        tabBar.alpha = 0.8
        viewControllers = viewModel.tabBarViewControllers
        delegate = self
        navigationController?.isNavigationBarHidden = true
    }
}

extension MainViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is CodeReaderViewController {
            viewModel.askUserPermissionForCameraUsage {
                tabBarController.selectedIndex = 1
            } onError: { [weak self] in
                guard let self = self else { return }
                tabBarController.selectedIndex = 0
                self.present(self.viewModel.createAlertView(), animated: true)
            }
            return false
        }
        
        return true
    }
}

extension MainViewController: RequestProtocol {
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

