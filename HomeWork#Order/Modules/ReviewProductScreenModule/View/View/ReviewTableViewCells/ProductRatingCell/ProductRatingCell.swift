//
//  ProductRatingCell.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 01.11.2024.
//

import UIKit

final class ProductRatingCell: UITableViewCell {
    
    static let identifier: String = String(describing: ProductRatingCell.self)
    
    private lazy var contentCellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = contentViewBackgroundColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var productRatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.text = "Ваша оценка"
        return label
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private var ratingStarsImageViewsArray: [UIImageView] = []
    
    private let contentViewBackgroundColor: UIColor = UIColor(red: 246.0 / 255.0, green: 246.0 / 255.0, blue: 246.0 / 255.0, alpha: 1)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setRatingImages()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension ProductRatingCell {
    
    func setupCell() {
        contentView.backgroundColor = .clear
        
        contentView.addSubview(contentCellView)
        contentCellView.addSubview(productRatingLabel)
        contentCellView.addSubview(ratingStackView)
        
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
            productRatingLabel.topAnchor.constraint(equalTo: contentCellView.topAnchor, constant: 16),
            productRatingLabel.leadingAnchor.constraint(equalTo: contentCellView.leadingAnchor, constant: 16),
            productRatingLabel.bottomAnchor.constraint(equalTo: contentCellView.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            ratingStackView.topAnchor.constraint(equalTo: contentCellView.topAnchor, constant: 16),
            ratingStackView.leadingAnchor.constraint(greaterThanOrEqualTo: productRatingLabel.trailingAnchor, constant: 16),
            ratingStackView.trailingAnchor.constraint(equalTo: contentCellView.trailingAnchor, constant: -24),
            ratingStackView.bottomAnchor.constraint(equalTo: contentCellView.bottomAnchor, constant: -16)
        ])
    }
    
    func setRatingImages() {
        for _ in 0..<5 {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "notFillStart")
            ratingStarsImageViewsArray.append(imageView)
            ratingStackView.addArrangedSubview(imageView)
        }
    }
}
