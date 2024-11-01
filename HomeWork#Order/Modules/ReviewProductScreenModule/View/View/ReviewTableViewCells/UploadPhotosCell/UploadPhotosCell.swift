//
//  UploadPhotosCell.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 01.11.2024.
//

import UIKit

final class UploadPhotosCell: UITableViewCell {
    
    static let identifier: String = String(describing: UploadPhotosCell.self)
    
    private lazy var contentCellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = contentViewBackgroundColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var uploadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "uploadImage")
        return imageView
    }()
    
    private lazy var addPhotoVideoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Добавьте фото или видео"
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var clickHereLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Нажмите, чтобы выбрать файлы"
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .left
        return label
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
}

private extension UploadPhotosCell {
    
    func setupCell() {
        contentView.backgroundColor = .clear
        
        contentView.addSubview(contentCellView)
        contentCellView.addSubview(uploadImageView)
        contentCellView.addSubview(addPhotoVideoLabel)
        contentCellView.addSubview(clickHereLabel)
        
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
            uploadImageView.widthAnchor.constraint(equalToConstant: 24),
            uploadImageView.heightAnchor.constraint(equalToConstant: 24),
            uploadImageView.leadingAnchor.constraint(equalTo: contentCellView.leadingAnchor, constant: 16),
            uploadImageView.centerYAnchor.constraint(equalTo: contentCellView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addPhotoVideoLabel.topAnchor.constraint(equalTo: contentCellView.topAnchor, constant: 16),
            addPhotoVideoLabel.leadingAnchor.constraint(equalTo: uploadImageView.trailingAnchor, constant: 16),
            addPhotoVideoLabel.trailingAnchor.constraint(equalTo: contentCellView.trailingAnchor, constant: -16),
            addPhotoVideoLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            clickHereLabel.topAnchor.constraint(equalTo: addPhotoVideoLabel.bottomAnchor, constant: 5),
            clickHereLabel.leadingAnchor.constraint(equalTo: addPhotoVideoLabel.leadingAnchor),
            clickHereLabel.trailingAnchor.constraint(equalTo: addPhotoVideoLabel.trailingAnchor),
            clickHereLabel.bottomAnchor.constraint(equalTo: contentCellView.bottomAnchor, constant: -16)
        ])
        
        clickHereLabel.heightAnchor.constraint(equalTo: addPhotoVideoLabel.heightAnchor).isActive = true
    }
}
