//
//  UserReviewCell.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 01.11.2024.
//

import UIKit

final class UserReviewCell: UITableViewCell {
    
    static let identifier: String = String(describing: UserReviewCell.self)
    
    private lazy var contentCellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = contentViewBackgroundColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let contentViewBackgroundColor: UIColor = UIColor(red: 246.0 / 255.0, green: 246.0 / 255.0, blue: 246.0 / 255.0, alpha: 1)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(placeholderText: String) {
        inputTextField.placeholder = placeholderText
    }
}

private extension UserReviewCell {
    
    func setupCell() {
        contentView.backgroundColor = .clear
        
        contentView.addSubview(contentCellView)
        contentCellView.addSubview(inputTextField)
        
        setupContstraints()
    }
    
    func setupContstraints() {
        NSLayoutConstraint.activate([
            contentCellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            contentCellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            contentCellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            contentCellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            inputTextField.topAnchor.constraint(equalTo: contentCellView.topAnchor, constant: 16),
            inputTextField.leadingAnchor.constraint(equalTo: contentCellView.leadingAnchor, constant: 16),
            inputTextField.trailingAnchor.constraint(equalTo: contentCellView.trailingAnchor, constant: -16),
            inputTextField.bottomAnchor.constraint(equalTo: contentCellView.bottomAnchor, constant: -16),
        ])
    }
}
