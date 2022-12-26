//
//  CustomNavigationBar.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 25/12/22.
//

import UIKit

protocol NavbarViewDelegate: AnyObject {
    func onButtonBackTapped()
}

class CustomNavigationBar: UIView {
    
    lazy var navbarLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .black)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var toolbarStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var navbarChevronButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "chevron.backward")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(onButtonBackTapped), for: .touchUpInside)
        return button
    }()
    
    /// Set this to True if you need back chevron for your navigation bar.
    var withBackButton: Bool
    weak var actionDelegate: NavbarViewDelegate?
    
    required init(title: String, withBackButton: Bool = false) {
        self.withBackButton = withBackButton
        super.init(frame: .zero)
        self.navbarLabel.text = title
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        [navbarLabel, toolbarStackView].forEach { subviews in
            addSubview(subviews)
        }
        if withBackButton { addSubview(navbarChevronButton) }
        backgroundColor = .lightGray
        setConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setConstraints()
    }
    
    func setConstraints() {
        if withBackButton {
            navbarChevronButton.anchor(
                top: nil,
                leading: self.safeAreaLayoutGuide.leadingAnchor,
                bottom: nil,
                trailing: nil,
                padding: .init(top: 0, left: 24, bottom: 0, right: 16),
                size: .init(width: 24, height: 24))
            navbarChevronButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        }
        
        toolbarStackView.anchor(
            top: nil,
            leading: nil,
            bottom: nil,
            trailing: trailingAnchor,
            padding: .init(top: 0, left: 0, bottom: 0, right: 24),
            size: .init(width: 0, height: 24))
        toolbarStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        navbarLabel.anchor(
            top: nil,
            leading: withBackButton ? navbarChevronButton.trailingAnchor : leadingAnchor,
            bottom: nil,
            trailing: toolbarStackView.leadingAnchor,
            padding: .init(top: 0, left: withBackButton ? 0 : 24, bottom: 0, right: 24),
            size: .init(width: 0, height: 24)
        )
        navbarLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    public func configureToolbar(_ items: [UIView]) {
        items.forEach { item in
            toolbarStackView.addArrangedSubview(item)
        }
        toolbarStackView.layoutSubviews()
    }
    
    @objc private func onButtonBackTapped() {
        actionDelegate?.onButtonBackTapped()
    }
}
