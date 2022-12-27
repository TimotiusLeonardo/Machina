//
//  MachineListCell.swift
//  Machina
//
//  Created by Timotius Leonardo Lianoto on 27/12/22.
//

import UIKit
import RealmSwift

class MachineListCell: UITableViewCell {
    private lazy var machineImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "testGambar")
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var idLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, idLabel])
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [machineImageView, verticalStackView])
        stackView.spacing = 16
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        [horizontalStackView].forEach { subview in
            contentView.addSubview(subview)
        }
        backgroundColor = .white
        setupConstraints()
    }
    
    private func setupConstraints() {
        horizontalStackView.anchor(top: contentView.topAnchor,
                                   leading: contentView.leadingAnchor,
                                   bottom: contentView.bottomAnchor,
                                   trailing: contentView.trailingAnchor,
                                   padding: .init(top: 12, left: 24, bottom: 12, right: 24),
                                   size: .init(width: 0, height: 80))
    }
    
    func setupCells(data: Machine?) {
        titleLabel.text = data?.name
        idLabel.text = data?.qrCodeNumber
        
//        if data?.imagesUrl.isEmpty == true {
//            machineImageView.isHidden = true
//        } else {
//            machineImageView.isHidden = false
//        }
    }
}
