//
//  MainViewModel.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 24/12/22.
//

import UIKit
import AVFoundation

final class MainViewModel: BaseViewModelContract {
    var requestDelegate: RequestProtocol?
    private let asyncDispatchQueue: DispatchQueue = DispatchQueue.main
    
    var state: ViewState = .idle {
        didSet {
            asyncDispatchQueue.async {
                self.requestDelegate?.updateState(with: self.state)
            }
        }
    }
    
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
    
    func askUserPermissionForCameraUsage(onSuccess: @escaping onSuccess, onError: @escaping onError) {
        state = .loading
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                self.state = .success(onSuccess)
                Log("Camera access granted")
            } else {
                Log("Camera access denied")
                self.state = .error(onError)
            }
        }
    }
    
    func createAlertView() -> UIAlertController {
        let alertView = UIAlertController(title: "Camera Access Denied",
                                          message: "This feature require your camera access, please allow it first it your phone settings preferences",
                                          preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .default))
        return alertView
    }
}
