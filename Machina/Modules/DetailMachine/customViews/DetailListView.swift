//
//  ListView.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 27/12/22.
//

import UIKit

protocol DetailListViewDelegate: AnyObject {
    func onUpdatedTextFieldValue()
}

class DetailListView: UIView {
    weak var delegate: DetailListViewDelegate?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    lazy var descriptionTextfield: UITextField = {
        let textField = UITextField()
        textField.font = .systemFont(ofSize: 12, weight: .regular)
        textField.placeholder = "Description"
        textField.textColor = .black
        textField.addTarget(self, action: #selector(onTextFieldChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionTextfield])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    init(title: String, description: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        descriptionTextfield.text = description
        createViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createViews() {
        [stackView].forEach { subview in
            addSubview(subview)
        }
        toggleTextFieldEnabled(to: false)
        configureConstraints()
    }
    
    private func configureConstraints() {
        stackView.anchor(top: topAnchor,
                         leading: leadingAnchor,
                         bottom: bottomAnchor,
                         trailing: trailingAnchor)
    }
    
    func toggleTextFieldEnabled(to state: Bool) {
        descriptionTextfield.isEnabled = state
        UIView.animate(withDuration: 0.2,
                       delay: 0) {
            self.descriptionTextfield.textColor = state ? .black : .lightGray
        }
    }
    
    func getValue() -> String? {
        descriptionTextfield.text
    }
    
    @objc func onTextFieldChanged() {
        delegate?.onUpdatedTextFieldValue()
    }
}
