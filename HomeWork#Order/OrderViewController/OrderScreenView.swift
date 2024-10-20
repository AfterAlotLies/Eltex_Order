//
//  OrderScreenView.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 16.10.2024.
//

import Foundation
import UIKit

protocol IOrderScreenView: AnyObject {
    func showErrorMessage(errorTitle: String, errorMessage: String)
}

final class OrderScreenView: UIView {
    
    private enum Constants {
        static let promocodeInfoLabelText = "На один товар можно применить только один промокод"
        static let activePromocodesButtonTitle = "Применить промокод"
        static let activePromocodeButtonImage = UIImage(named: "promocode")
        static let hidePromocodesButtonTitle = "Скрыть промокоды"
        static let alertErrorTitle = "Что-то пошло не так..."
        static let topAnchorMargin: CGFloat = 16
        static let leadingAnchorMargin: CGFloat = 16
        static let trailingAnchorMargin: CGFloat = -16
    }
    
    private lazy var orderScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bouncesVertically = true
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dividerTopView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColorProperties.dividerTopViewColor
        return view
    }()
    
    private lazy var promocodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()
    
    private lazy var promocodeInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.promocodeInfoLabelText
        label.textAlignment = .left
        label.textColor = UIColorProperties.grayLabelColor
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var activePromocodesButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.activePromocodesButtonTitle, for: .normal)
        button.setImage(Constants.activePromocodeButtonImage, for: .normal)
        button.tintColor = UIColorProperties.promocodeButtonColorsProperties
        button.setTitleColor(UIColorProperties.promocodeButtonColorsProperties, for: .normal)
        button.backgroundColor = UIColorProperties.activePromocodeButtonBackgroundColor
        button.layer.cornerRadius = 10
        button.imageEdgeInsets.left = -25
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.clear.cgColor
        return button
    }()
    
    private lazy var promocodesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 90
        tableView.register(PromocodesTableViewCell.self, forCellReuseIdentifier: PromocodesTableViewCell.identifer)
        return tableView
    }()
    
    private lazy var hidePromocodesButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.hidePromocodesButtonTitle, for: .normal)
        button.setTitleColor(UIColorProperties.promocodeButtonColorsProperties, for: .normal)
        return button
    }()
    
    private lazy var bottomOrderView: BottomOrderScreenView = {
        let view = BottomOrderScreenView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var tableViewHeightConstraint: NSLayoutConstraint?
    private var countOfChoosenPromocodes: Int = 0
    private var order: Order?
    
    weak var delegate: IOrderScreenView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let contentHeight = promocodesTableView.contentSize.height
        tableViewHeightConstraint?.constant = contentHeight
        contentView.layoutIfNeeded()
        orderScrollView.contentSize = contentView.frame.size
    }
    
}

extension OrderScreenView {
    
    func showOrder(_ order: Order) {
        self.order = order
        
        if order.products.isEmpty {
            delegate?.showErrorMessage(errorTitle: Constants.alertErrorTitle, errorMessage: "Продуктов нет")
        }
        
        order.products.forEach {
            if $0.price <= 0 {
                delegate?.showErrorMessage(errorTitle: Constants.alertErrorTitle, errorMessage: "Не может быть цена продукта меньше или равна 0")
            }
        }
        
        for orderProd in order.products {
            if orderProd.price < order.baseDiscount ?? 0 {
                delegate?.showErrorMessage(errorTitle: Constants.alertErrorTitle, errorMessage: "Не может текущая скидка быть больше чем сумма заказа")
            }
        }
        
        promocodeLabel.text = order.screenTitle
        bottomOrderView.setData(order)
        promocodesTableView.reloadData()
    }
}

extension OrderScreenView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let order = order else {
            return 0
        }
        return order.promocodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PromocodesTableViewCell.identifer, for: indexPath) as? PromocodesTableViewCell,
        let order = order else {
            return UITableViewCell()
        }
        
        cell.setSwitchHandler { [weak self] isOn in
            self?.handleSwitch(isOn, indexPath: indexPath.row, cell: cell)
        }
        
        if order.promocodes[indexPath.row].active == true {
            countOfChoosenPromocodes += 1
            if countOfChoosenPromocodes > 2 {
                delegate?.showErrorMessage(errorTitle: Constants.alertErrorTitle, errorMessage: "Было активировано более 2-х промокодов")
                tableView.isHidden = true
                showErrorLabel()
            }
        }
        
        cell.configureCell(order.promocodes[indexPath.row])
        
        return cell
    }
    
}

private extension OrderScreenView {
    
    func showErrorLabel() {
        let errorLabel = UILabel()
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.text = Constants.alertErrorTitle
        errorLabel.textAlignment = .center
        errorLabel.font = UIFont.boldSystemFont(ofSize: 24)
        addSubview(errorLabel)
        errorLabel.topAnchor.constraint(equalTo: activePromocodesButton.bottomAnchor, constant: 16).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        errorLabel.bottomAnchor.constraint(equalTo: hidePromocodesButton.topAnchor, constant: -16).isActive = true
    }
    
    func handleSwitch(_ isOn: Bool, indexPath: Int, cell: PromocodesTableViewCell) {
        guard let order = order else { return }
        if isOn {
            if countOfChoosenPromocodes < 2 {
                countOfChoosenPromocodes += 1
                bottomOrderView.applyDiscount(order.promocodes[indexPath])
            } else {
                delegate?.showErrorMessage(errorTitle: Constants.alertErrorTitle, errorMessage: "Вы не можете активировать более 2-х промокодов одновременно")
                cell.turnOffSwitch()
            }
        } else {
            countOfChoosenPromocodes -= 1
            bottomOrderView.removeDiscount(order.promocodes[indexPath])

        }
    }
    
    func setupView() {
        addSubview(orderScrollView)

        orderScrollView.addSubview(contentView)

        contentView.addSubview(dividerTopView)
        contentView.addSubview(promocodeLabel)
        contentView.addSubview(promocodeInfoLabel)
        contentView.addSubview(activePromocodesButton)
        contentView.addSubview(promocodesTableView)
        contentView.addSubview(hidePromocodesButton)
        contentView.addSubview(bottomOrderView)

        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            orderScrollView.topAnchor.constraint(equalTo: topAnchor),
            orderScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            orderScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            orderScrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: orderScrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: orderScrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: orderScrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: orderScrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: orderScrollView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            dividerTopView.topAnchor.constraint(equalTo: contentView.topAnchor),
            dividerTopView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dividerTopView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dividerTopView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        NSLayoutConstraint.activate([
            promocodeLabel.topAnchor.constraint(equalTo: dividerTopView.bottomAnchor, constant: Constants.topAnchorMargin),
            promocodeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingAnchorMargin),
            promocodeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingAnchorMargin)
        ])
        
        tableViewHeightConstraint = promocodesTableView.heightAnchor.constraint(equalToConstant: 120)
        tableViewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            promocodeInfoLabel.topAnchor.constraint(equalTo: promocodeLabel.bottomAnchor, constant: Constants.topAnchorMargin),
            promocodeInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingAnchorMargin),
            promocodeInfoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingAnchorMargin)
        ])
        
        NSLayoutConstraint.activate([
            activePromocodesButton.topAnchor.constraint(equalTo: promocodeInfoLabel.bottomAnchor, constant: Constants.topAnchorMargin),
            activePromocodesButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingAnchorMargin),
            activePromocodesButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingAnchorMargin),
            activePromocodesButton.heightAnchor.constraint(equalToConstant: 54)
        ])
        
        NSLayoutConstraint.activate([
            promocodesTableView.topAnchor.constraint(equalTo: activePromocodesButton.bottomAnchor, constant: Constants.topAnchorMargin),
            promocodesTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingAnchorMargin),
            promocodesTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Constants.trailingAnchorMargin)
        ])
        
        NSLayoutConstraint.activate([
            hidePromocodesButton.topAnchor.constraint(equalTo: promocodesTableView.bottomAnchor, constant: 8),
            hidePromocodesButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.leadingAnchorMargin),
            hidePromocodesButton.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: Constants.trailingAnchorMargin),
            hidePromocodesButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            bottomOrderView.topAnchor.constraint(greaterThanOrEqualTo: hidePromocodesButton.bottomAnchor, constant: Constants.topAnchorMargin),
            bottomOrderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomOrderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomOrderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomOrderView.heightAnchor.constraint(equalToConstant: 350)
        ])
    }
}
