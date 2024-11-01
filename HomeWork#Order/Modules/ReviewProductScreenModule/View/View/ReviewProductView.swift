//
//  ReviewProductView.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 31.10.2024.
//

import UIKit

final class ReviewProductView: UIView {
    
    private lazy var reviewTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(ProductInfoCell.self, forCellReuseIdentifier: ProductInfoCell.identifier)
        tableView.register(ProductRatingCell.self, forCellReuseIdentifier: ProductRatingCell.identifier)
        tableView.register(UploadPhotosCell.self, forCellReuseIdentifier: UploadPhotosCell.identifier)
        tableView.register(UserReviewCell.self, forCellReuseIdentifier: UserReviewCell.identifier)
        tableView.register(CheckBoxCell.self, forCellReuseIdentifier: CheckBoxCell.identifier)
        tableView.register(ConfirmReviewCell.self, forCellReuseIdentifier: ConfirmReviewCell.identifier)
        return tableView
    }()
    
    private let viewModel: ReviewProductViewModel
    
    init(frame: CGRect, viewModel: ReviewProductViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ReviewProductView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableViewCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModel.tableViewCells[indexPath.row]
        
        switch cellType {
        case .productInfo(let imageName, let productName, let productSize):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductInfoCell.identifier, for: indexPath) as? ProductInfoCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.configureCell(imageName: imageName, productName: productName, productSize: productSize)
            return cell

        case .productRating:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductRatingCell.identifier, for: indexPath) as? ProductRatingCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            return cell

        case .productPhotoUpload:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UploadPhotosCell.identifier, for: indexPath) as? UploadPhotosCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            return cell

        case .productUserReview(let textFieldPlaceHolder):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserReviewCell.identifier, for: indexPath) as? UserReviewCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.configureCell(placeholderText: textFieldPlaceHolder)
            return cell

        case .checkBox(let title):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CheckBoxCell.identifier, for: indexPath) as? CheckBoxCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.configureCell(with: title)
            return cell

        case .submitButton(let buttonTitle):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ConfirmReviewCell.identifier, for: indexPath) as? ConfirmReviewCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.configureUI(with: buttonTitle)
            return cell
        }
    }
    
}

private extension ReviewProductView {
    
    func setupView() {
        addSubview(reviewTableView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            reviewTableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            reviewTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            reviewTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            reviewTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
