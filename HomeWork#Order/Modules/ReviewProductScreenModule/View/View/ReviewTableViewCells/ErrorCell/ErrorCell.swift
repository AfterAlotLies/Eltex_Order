//
//  ErrorCell.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 03.11.2024.
//

import UIKit

final class ErrorCell: UITableViewCell {
    
    static let identifier: String = String(describing: ErrorCell.self)
    
    private lazy var contentCellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = contentViewBackgroundColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.text = "Для продолжения поставьте оценку\nтовару"
        label.textColor = .red
        return label
    }()
    
    private lazy var errorMarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "errorMark")
        return imageView
    }()
    
    private let contentViewBackgroundColor: UIColor = UIColor(red: 255.0 / 255.0, green: 236.0 / 255.0, blue: 236.0 / 255.0, alpha: 1)

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ErrorCell {
    
    func setupCell() {
        contentView.addSubview(contentCellView)
        contentCellView.addSubview(errorLabel)
        contentCellView.addSubview(errorMarkImageView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentCellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            contentCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            contentCellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            contentCellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: contentCellView.topAnchor, constant: 16),
            errorLabel.leadingAnchor.constraint(equalTo: contentCellView.leadingAnchor, constant: 16),
            errorLabel.bottomAnchor.constraint(equalTo: contentCellView.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            errorMarkImageView.centerYAnchor.constraint(equalTo: errorLabel.centerYAnchor),
            errorMarkImageView.leadingAnchor.constraint(equalTo: errorLabel.trailingAnchor, constant: 8),
            errorMarkImageView.trailingAnchor.constraint(equalTo: contentCellView.trailingAnchor, constant: -8),
            errorMarkImageView.widthAnchor.constraint(equalToConstant: 20),
            errorMarkImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
