//
//  AddPhotoCell.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 02.11.2024.
//

import UIKit

final class AddPhotoCell: UICollectionViewCell {
    
    static let identifier: String = String(describing: AddPhotoCell.self)
    
    private enum Constants {
        static let uploadImage = UIImage(named: "uploadImage")
    }
    
    private lazy var addPhotoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Constants.uploadImage, for: .normal)
        button.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        return button
    }()
    
    private let contentViewBackgroundColor: UIColor = UIColor(red: 246.0 / 255.0, green: 246.0 / 255.0, blue: 246.0 / 255.0, alpha: 1)
    
    var viewModel: ReviewProductViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AddPhotoCell {
    
    @objc
    func addPhoto() {
        viewModel?.onUploadPhoto?()
    }
    
    
    func setupCell() {
        contentView.addSubview(addPhotoButton)
        contentView.backgroundColor = contentViewBackgroundColor
        contentView.layer.cornerRadius = 10
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            addPhotoButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addPhotoButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
