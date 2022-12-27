//
//  DetailMachineImageCollectionViewCell.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 28/12/22.
//

import UIKit

class DetailMachineImageCollectionViewCell: UICollectionViewCell {
    
    private lazy var machineImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setup(image: UIImage?) {
        machineImageView.image = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [machineImageView].forEach { subview in
            contentView.addSubview(subview)
        }
        backgroundColor = .white
        setupConstraints()
    }
    
    private func setupConstraints() {
        machineImageView.anchor(top: contentView.topAnchor,
                                leading: contentView.leadingAnchor,
                                bottom: contentView.bottomAnchor,
                                trailing: contentView.trailingAnchor,
                                padding: .zero,
                                size: .zero)
    }
}
