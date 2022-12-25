//
//  CustomNavigationBar.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 25/12/22.
//

import UIKit

class CustomNavigationBar: UIView {
    private lazy var label: UILabel = {
         let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()
    
    private lazy var statusBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = statusBarView.backgroundColor
        return view
    }()
    
    private lazy var statusBarHeight: CGFloat = UIApplication.statusBarHeight
    
    init(text: String) {
        super.init(frame: .zero)
        label.text = text
        createView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createView() {
        [statusBarView, containerView].forEach { view in
            addSubview(view)
        }
        containerView.addSubview(label)
        configureConstraints()
    }
    
    func configureConstraints() {
        statusBarView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, size: .init(width: 0, height: statusBarHeight))
        containerView.anchor(top: statusBarView.bottomAnchor, leading: statusBarView.leadingAnchor, bottom: nil, trailing: statusBarView.trailingAnchor, size: .init(width: 0, height: 80))
        label.anchor(top: nil, leading: containerView.leadingAnchor, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 16, right: 0))
    }
}
