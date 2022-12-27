//
//  UIViewController+Extensions.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 27/12/22.
//

import UIKit

extension UIViewController {
    enum ToastMessageType {
        case success
        case error
    }
    
    func showToast(message : String, type: ToastMessageType) {
        // Delete existing toast if exist
        if let availableView = view.viewWithTag(123) {
            availableView.removeFromSuperview()
        }
        
        let toastLabel = UILabel()
        let backgroundView = UIView()
        toastLabel.textColor = UIColor.white
        toastLabel.font = .systemFont(ofSize: 12, weight: .bold)
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.clipsToBounds  =  true
        backgroundView.tag = 123
        backgroundView.backgroundColor = type == .success ? UIColor(red: 17/255, green: 125/255, blue: 5/255, alpha: 0.6) : UIColor.red.withAlphaComponent(0.6)
        backgroundView.layer.cornerRadius = 8;
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(toastLabel)
        self.view.addSubview(backgroundView)
        backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        backgroundView.widthAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
        toastLabel.anchor(top: backgroundView.topAnchor,
                          leading: backgroundView.leadingAnchor,
                          bottom: backgroundView.bottomAnchor,
                          trailing: backgroundView.trailingAnchor,
                          padding: .init(top: 8, left: 16, bottom: 8, right: 16),
                          size: .zero)
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            backgroundView.alpha = 0.0
        }, completion: {(isCompleted) in
            backgroundView.removeFromSuperview()
        })
    }
}
