//
//  MainViewModel.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 24/12/22.
//

import UIKit

final class MainViewModel {
    var tabBarViewControllers: [UIViewController] {
        var viewControllers = [UIViewController]()
        // Create List Machine Controller
        let machineListViewController = MachineListViewController(viewModel: MachineListViewModel())
        machineListViewController.tabBarItem.title = "Machines"
        machineListViewController.tabBarItem.image = UIImage(systemName: "wrench.and.screwdriver")
        viewControllers.append(UINavigationController(rootViewController: machineListViewController))
        
        // Create Code Reader Controller
        let codeReaderViewController = CodeReaderViewController(viewModel: CodeReaderViewModel())
        codeReaderViewController.tabBarItem.title = "Code Reader"
        codeReaderViewController.tabBarItem.image = UIImage(systemName: "qrcode.viewfinder")
        viewControllers.append(codeReaderViewController)
        
        return viewControllers
    }
}
