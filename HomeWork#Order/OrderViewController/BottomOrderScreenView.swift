//
//  BottomOrderScreenView.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 17.10.2024.
//

import Foundation
import UIKit

final class BottomOrderScreenView: UIView {
    
    private enum Constants {
        static let saleLabelText = "Скидки"
        static let promocodesLabelText = "Промокоды"
        static let promocodeInfoButtonImage = UIImage(named: "info_circle")
        static let paymentLabelText = "Способ оплаты"
        static let totalLabelText = "Итого"
        static let makeAnOrderButtonTitle = "Оформить заказ"
        static let topAnchorMargin: CGFloat = 16
        static let leadingAnchorMargin: CGFloat = 26
        static let trailingAnchorMargin: CGFloat = -26
        static let fontLabelSize: CGFloat = 14
    }
    
    private lazy var priceForTwoProductsLabel: UILabel = createLabel(fontSize: UIFont.systemFont(ofSize: Constants.fontLabelSize))
    private lazy var saleLabel: UILabel = createLabel(fontSize: UIFont.systemFont(ofSize: Constants.fontLabelSize), textLabel: Constants.saleLabelText)
    private lazy var promocodesLabel: UILabel = createLabel(fontSize: UIFont.systemFont(ofSize: Constants.fontLabelSize), textLabel: Constants.promocodesLabelText)
    private lazy var paymentLabel: UILabel = createLabel(fontSize: UIFont.systemFont(ofSize: Constants.fontLabelSize), textLabel: Constants.paymentLabelText)
    private lazy var priceLabel: UILabel = createLabel(fontSize: UIFont.systemFont(ofSize: Constants.fontLabelSize))
    private lazy var salePriceLabel: UILabel = createLabel(fontSize: UIFont.systemFont(ofSize: Constants.fontLabelSize), textColor: UIColorProperties.salePriceLabelColorsProperties)
    private lazy var promocodesPriceLabel: UILabel = createLabel(fontSize: UIFont.systemFont(ofSize: Constants.fontLabelSize), textColor: UIColorProperties.promocodesPriceLabelColorsProperties)
    private lazy var paymentPriceLabel: UILabel = createLabel(fontSize: UIFont.systemFont(ofSize: Constants.fontLabelSize))
    private lazy var totalLabel: UILabel = createLabel(fontSize: UIFont.systemFont(ofSize: 18), textLabel: Constants.totalLabelText)
    private lazy var totalPriceLabel: UILabel = createLabel(fontSize: UIFont.systemFont(ofSize: Constants.fontLabelSize))
    
    private lazy var promocodeInfoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Constants.promocodeInfoButtonImage, for: .normal)
        return button
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    private lazy var makeAnOrderButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.makeAnOrderButtonTitle, for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColorProperties.makeAnOrderButtonColorsProperties
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let attributedString = NSMutableAttributedString()
        let firstPart = NSAttributedString(string: "Нажимая кнопку «Оформить заказ»,\nВы соглашаетесь на",
                                           attributes: [
                                            .font: UIFont.systemFont(ofSize: 12),
                                            .foregroundColor: UIColor.lightGray
                                           ])
        
        let secondPart = NSAttributedString(string: " Условия оферты", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor: UIColor.black
        ])
        
        attributedString.append(firstPart)
        attributedString.append(secondPart)
        
        label.attributedText = attributedString
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private var totalSumMain = 0.0
    private var totalSum = 0.0
    private var activePromocodes: [Order.Promocode] = []
    private var fixedDiscount: Double = 0.0
    private var paymentDiscount: Double = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension BottomOrderScreenView {
    
    func setData(_ data: Order) {
        totalSumMain = data.products.reduce(0) { $0 + $1.price }
        totalSum = totalSumMain
        fixedDiscount = data.baseDiscount ?? 0
        paymentDiscount = data.paymentDiscount ?? 0
        
        data.promocodes.forEach { promocode in
            if promocode.active {
                activePromocodes.append(promocode)
            }
        }
        
        priceLabel.text = "\(formatPrice(Int(totalSum))) ₽"
        salePriceLabel.text = "- \(formatPrice(Int(fixedDiscount))) ₽"
        paymentPriceLabel.text = "- \(formatPrice(Int(paymentDiscount))) ₽"
        priceForTwoProductsLabel.text = "Цена за \(data.products.count) \(getCorrectProductText(for: data.products.count))"
        
        recalculateTotalSum()
        updateUI()
    }
    
    func applyDiscount(_ promocode: Order.Promocode) {
        activePromocodes.append(promocode)
        recalculateTotalSum()
        updateUI()
    }
    
    func removeDiscount(_ promocode: Order.Promocode) {
        activePromocodes.removeAll { $0.title == promocode.title }
        recalculateTotalSum()
        updateUI()
    }
}

private extension BottomOrderScreenView {
    
    func formatPrice(_ price: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = " "
        numberFormatter.maximumFractionDigits = 0
        
        if let formattedPrice = numberFormatter.string(from: NSNumber(value: price)) {
            return formattedPrice
        }
        
        return "\(price)"
    }
    
    func createLabel(fontSize: UIFont, textLabel: String?=nil, textColor: UIColor?=nil) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = fontSize
        if let textLabel = textLabel {
            label.text = textLabel
        }
        if let textColor = textColor {
            label.textColor = textColor
        }
        return label
    }
    
    func recalculateTotalSum() {
        var discountSum: Double = 0.0
        var totalDiscountPercent: Int = 0
        
        activePromocodes.forEach { promocode in
            let discount = (totalSumMain * Double(promocode.percent)) / 100
            discountSum += discount
            totalDiscountPercent += Int(discount)
        }
        
        totalSum = totalSumMain - discountSum - fixedDiscount - paymentDiscount
        
        promocodesPriceLabel.text = "- \(formatPrice(totalDiscountPercent)) ₽"
    }
    
    func updateUI() {
        totalPriceLabel.text = "\(formatPrice(Int(totalSum))) ₽"
    }
    
    func getCorrectProductText(for count: Int) -> String {
        let lastDigit = count % 10
        let lastTwoDigits = count % 100
        
        if (11...14).contains(lastTwoDigits) {
            return "товаров"
        }
        
        switch lastDigit {
        case 1:
            return "товар"
        case 2, 3, 4:
            return "товара"
        default:
            return "товаров"
        }
    }
    
    func setupView() {
        backgroundColor = UIColorProperties.grayBackgroundColor
        
        addSubview(priceForTwoProductsLabel)
        addSubview(saleLabel)
        addSubview(promocodesLabel)
        addSubview(promocodeInfoButton)
        addSubview(paymentLabel)
        
        addSubview(priceLabel)
        addSubview(salePriceLabel)
        addSubview(promocodesPriceLabel)
        addSubview(paymentPriceLabel)
        
        addSubview(dividerView)
        
        addSubview(totalLabel)
        addSubview(totalPriceLabel)
        
        addSubview(makeAnOrderButton)
        
        addSubview(infoLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            priceForTwoProductsLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.topAnchorMargin),
            priceForTwoProductsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.leadingAnchorMargin),
            priceForTwoProductsLabel.trailingAnchor.constraint(greaterThanOrEqualTo: priceLabel.leadingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.topAnchorMargin),
            priceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.trailingAnchorMargin)
        ])
        
        NSLayoutConstraint.activate([
            saleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.leadingAnchorMargin),
            saleLabel.topAnchor.constraint(equalTo: priceForTwoProductsLabel.bottomAnchor, constant: Constants.topAnchorMargin),
            saleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: salePriceLabel.leadingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            salePriceLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: Constants.topAnchorMargin),
            salePriceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.trailingAnchorMargin)
        ])
        
        NSLayoutConstraint.activate([
            promocodesLabel.topAnchor.constraint(equalTo: saleLabel.bottomAnchor, constant: Constants.topAnchorMargin),
            promocodesLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.leadingAnchorMargin),
            promocodesLabel.trailingAnchor.constraint(equalTo: promocodeInfoButton.leadingAnchor, constant: -6)
        ])
        
        NSLayoutConstraint.activate([
            promocodeInfoButton.heightAnchor.constraint(equalToConstant: 20),
            promocodeInfoButton.widthAnchor.constraint(equalToConstant: 20),
            promocodeInfoButton.centerYAnchor.constraint(equalTo: promocodesLabel.centerYAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            promocodesPriceLabel.topAnchor.constraint(equalTo: salePriceLabel.bottomAnchor, constant: Constants.topAnchorMargin),
            promocodesPriceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.trailingAnchorMargin)
        ])
        
        NSLayoutConstraint.activate([
            paymentLabel.topAnchor.constraint(equalTo: promocodesLabel.bottomAnchor, constant: Constants.topAnchorMargin),
            paymentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.leadingAnchorMargin),
            paymentLabel.trailingAnchor.constraint(greaterThanOrEqualTo: paymentPriceLabel.leadingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            paymentPriceLabel.topAnchor.constraint(equalTo: promocodesPriceLabel.bottomAnchor, constant: Constants.topAnchorMargin),
            paymentPriceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.trailingAnchorMargin)
        ])
        
        NSLayoutConstraint.activate([
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            dividerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.leadingAnchorMargin),
            dividerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.trailingAnchorMargin),
            dividerView.topAnchor.constraint(equalTo: paymentLabel.bottomAnchor, constant: 36)
        ])
        
        NSLayoutConstraint.activate([
            totalLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: Constants.topAnchorMargin),
            totalLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.leadingAnchorMargin),
            totalLabel.trailingAnchor.constraint(greaterThanOrEqualTo: totalPriceLabel.leadingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            totalPriceLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: Constants.topAnchorMargin),
            totalPriceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.trailingAnchorMargin)
        ])
        
        NSLayoutConstraint.activate([
            makeAnOrderButton.heightAnchor.constraint(equalToConstant: 54),
            makeAnOrderButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.leadingAnchorMargin),
            makeAnOrderButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: Constants.trailingAnchorMargin),
            makeAnOrderButton.topAnchor.constraint(greaterThanOrEqualTo: totalLabel.bottomAnchor, constant: Constants.topAnchorMargin)
        ])
        
        NSLayoutConstraint.activate([
            infoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            infoLabel.topAnchor.constraint(equalTo: makeAnOrderButton.bottomAnchor, constant: 4),
            infoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
}
