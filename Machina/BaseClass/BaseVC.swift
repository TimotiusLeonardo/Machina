//
//  BaseVC.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 25/12/22.
//

import UIKit

class BaseVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.isHidden = true
        tabBarController?.navigationController?.isNavigationBarHidden = true
        tabBarController?.navigationController?.navigationBar.isHidden = true
    }
}
