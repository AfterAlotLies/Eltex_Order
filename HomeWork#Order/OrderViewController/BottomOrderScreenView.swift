//
//  BottomOrderScreenView.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 17.10.2024.
//

import Foundation
import UIKit

final class BottomOrderScreenView: UIView {
    
    private let viewBackground: UIColor = UIColor(red: 246.0 / 255.0, green: 246.0 / 255.0, blue: 246.0 / 255.0, alpha: 1)
    private let makeAnOrderButtonColorsProperties: UIColor = UIColor(red: 255.0 / 255.0, green: 70.0 / 255.0, blue: 17.0 / 255.0, alpha: 1)
    private let salePriceLabelColorsProperties: UIColor = UIColor(red: 255.0 / 255.0, green: 70.0 / 255.0, blue: 17.0 / 255.0, alpha: 1)
    private let promocodesPriceLabelColorsProperties: UIColor = UIColor(red: 0.0 / 255.0, green: 183.0 / 255.0, blue: 117.0 / 255.0, alpha: 1)
    
    private var totalSumMain = 0.0
    private var totalSum = 0.0
    private var countOfChoosenPromocodes = 0
    private var previousDiscount = 0.0
    
    private lazy var priceForTwoProductsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Цена за 2 товара"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var saleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Скидки"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var promocodesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Промокоды"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var promocodeInfoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "info_circle"), for: .normal)
        return button
    }()
    
    private lazy var paymentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Способы оплаты"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "25 000 ₽"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var salePriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "-5 000 ₽"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = salePriceLabelColorsProperties
        return label
    }()
    
    private lazy var promocodesPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "-5 000 ₽"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = promocodesPriceLabelColorsProperties
        return label
    }()
    
    private lazy var paymentPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "-5 000 ₽"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Итого"
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var totalPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "19 000 ₽"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var makeAnOrderButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Оформить заказ", for: .normal)
        button.tintColor = .white
        button.backgroundColor = makeAnOrderButtonColorsProperties
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ data: Order) {
        let productsCount = data.products.count
        let productText = getCorrectProductText(for: productsCount)
        priceForTwoProductsLabel.text = "Цена за \(productsCount) \(productText)"
        data.products.forEach {
           totalSumMain += $0.price
        }
        
        promocodesPriceLabel.text = "\(Int(data.paymentDiscount ?? 0)) ₽"
        
        let payment = data.paymentDiscount ?? 0 + (data.baseDiscount ?? 0)
        
        paymentPriceLabel.text = "\(Int(payment)) ₽"
        
        totalPriceLabel.text = "\(Int(totalSumMain)) ₽"
        
        if totalSumMain <= 0.0 {
            priceLabel.text = "-"
        } else {
            priceLabel.text = "\(Int(totalSumMain)) ₽"
        }
        totalSum = totalSumMain
        
        data.products.forEach {
            if $0.price < data.baseDiscount ?? 0 {
                salePriceLabel.text = "0 ₽"
            } else {
                salePriceLabel.text = "\(Int(data.baseDiscount ?? 0)) ₽"
            }
        }
    }
    
    func updateDiscountSale(discount: Int, order: Order, isOn: Bool) {
        if isOn && countOfChoosenPromocodes == 0 {
            let firstDiscount = (totalSum * Double(discount)) / 100
            totalSum -= firstDiscount
            if countOfChoosenPromocodes == 2 {
                previousDiscount = firstDiscount
                let secondDiscount = (totalSum * Double(discount)) / 10
                totalSum -= secondDiscount
                promocodesPriceLabel.text = "\(Int(secondDiscount)) ₽"
                totalPriceLabel.text = "\(Int(totalSum)) ₽"
                countOfChoosenPromocodes += 1
            } else {
                promocodesPriceLabel.text = "\(Int(firstDiscount)) ₽"
                totalPriceLabel.text = "\(Int(totalSum)) ₽"
                countOfChoosenPromocodes += 1
            }
        }
        
        
        else {
            totalSum = totalSumMain
            totalPriceLabel.text = "\(Int(totalSumMain)) ₽"
            promocodesPriceLabel.text = "\(Int(order.paymentDiscount ?? 0)) ₽"
        }
    }
    
}

private extension BottomOrderScreenView {
    
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
        backgroundColor = viewBackground
        
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
            priceForTwoProductsLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            priceForTwoProductsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 26),
            priceForTwoProductsLabel.trailingAnchor.constraint(greaterThanOrEqualTo: priceLabel.leadingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            priceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -26)
        ])
        
        NSLayoutConstraint.activate([
            saleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 26),
            saleLabel.topAnchor.constraint(equalTo: priceForTwoProductsLabel.bottomAnchor, constant: 16),
            saleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: salePriceLabel.leadingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            salePriceLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),
            salePriceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -26)
        ])
        
        NSLayoutConstraint.activate([
            promocodesLabel.topAnchor.constraint(equalTo: saleLabel.bottomAnchor, constant: 16),
            promocodesLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 26),
            promocodesLabel.trailingAnchor.constraint(equalTo: promocodeInfoButton.leadingAnchor, constant: -6)
        ])
        
        NSLayoutConstraint.activate([
            promocodeInfoButton.heightAnchor.constraint(equalToConstant: 20),
            promocodeInfoButton.widthAnchor.constraint(equalToConstant: 20),
            promocodeInfoButton.centerYAnchor.constraint(equalTo: promocodesLabel.centerYAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            promocodesPriceLabel.topAnchor.constraint(equalTo: salePriceLabel.bottomAnchor, constant: 16),
            promocodesPriceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -26)
        ])
        
        NSLayoutConstraint.activate([
            paymentLabel.topAnchor.constraint(equalTo: promocodesLabel.bottomAnchor, constant: 16),
            paymentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 26),
            paymentLabel.trailingAnchor.constraint(greaterThanOrEqualTo: paymentPriceLabel.leadingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            paymentPriceLabel.topAnchor.constraint(equalTo: promocodesPriceLabel.bottomAnchor, constant: 16),
            paymentPriceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -26)
        ])
        
        NSLayoutConstraint.activate([
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            dividerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 26),
            dividerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -26),
            dividerView.topAnchor.constraint(equalTo: paymentLabel.bottomAnchor, constant: 36)
        ])
        
        NSLayoutConstraint.activate([
            totalLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 16),
            totalLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 26),
            totalLabel.trailingAnchor.constraint(greaterThanOrEqualTo: totalPriceLabel.leadingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            totalPriceLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 16),
            totalPriceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -26)
        ])
        
        NSLayoutConstraint.activate([
            makeAnOrderButton.heightAnchor.constraint(equalToConstant: 54),
            makeAnOrderButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 26),
            makeAnOrderButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -26),
            makeAnOrderButton.topAnchor.constraint(greaterThanOrEqualTo: totalLabel.bottomAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            infoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            infoLabel.topAnchor.constraint(equalTo: makeAnOrderButton.bottomAnchor, constant: 4),
            infoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }
}
