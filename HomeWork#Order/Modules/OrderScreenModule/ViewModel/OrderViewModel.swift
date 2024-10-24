//
//  OrderViewModel.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 22.10.2024.
//

import Foundation

protocol OrderViewModelDelegate: AnyObject {
    func setData(_ data: Order)
    func showErrorAlert(_ titleError: String, _ messageError: String)
    func countOfChoosenPromocodesDidChanged(_ count: Int)
    func isActiveCellDidChanged(_ index: Int)
    func didUpdateTotalSum(_ totalSum: Double, totalDiscount: Double)
}

final class OrderViewModel {
    
    private var data: Order? {
        didSet {
            if let data = data {
                delegate?.setData(data)
            }
        }
    }
    
    private var errorMessage: String = "" {
        didSet {
            delegate?.showErrorAlert("Что-то пошло не так...", errorMessage)
        }
    }
    
    private var countOfChoosenPromocodes: Int = 0 {
        didSet {
            delegate?.countOfChoosenPromocodesDidChanged(countOfChoosenPromocodes)
        }
    }
    
    private var isActiveCell: Int? {
        didSet {
            if let isActiveCell {
                delegate?.isActiveCellDidChanged(isActiveCell)
            }
        }
    }
    
    private var totalSum = 0.0 {
        didSet {
            notifyUpdate()
        }
    }
    
    private var totalSumMain = 0.0
    private var activePromocodes: [Order.Promocode] = []
    private var fixedDiscount: Double = 0.0
    private var paymentDiscount: Double = 0.0

    
    weak var delegate: OrderViewModelDelegate?
}

extension OrderViewModel {
    
    func setData() {
        let order = (Order(screenTitle: "Промокоды",
                                        promocodes: [Order.Promocode.init(title: "HELLO",
                                                                          percent: 5,
                                                                          endDate: Date(),
                                                                          info: "Промокод действует на первый заказ в приложении",
                                                                          active: true),
                                                     Order.Promocode.init(title: "VESNA23",
                                                                          percent: 5,
                                                                          endDate: Date(),
                                                                          info: "Промокод действует для заказов от 30 000 ₽",
                                                                          active: false),
                                                     Order.Promocode.init(title: "4300162112532",
                                                                          percent: 5,
                                                                          endDate: Date(),
                                                                          info: nil,
                                                                          active: false),
                                                     Order.Promocode.init(title: "4300162112534",
                                                                          percent: 5,
                                                                          endDate: Date(),
                                                                          info: nil,
                                                                          active: false),
                                                     Order.Promocode.init(title: "4300162112531",
                                                                          percent: 15,
                                                                          endDate: Date(),
                                                                          info: nil,
                                                                          active: true)],
                                        products: [Order.Product.init(price: 30000.0, title: "Продукты"),
                                                   Order.Product(price: 5000.0, title: "Chto-to")],
                                        paymentDiscount: 1000.0,
                                        baseDiscount: 1000.0))
        self.data = order
        isDataCorrect()
        setupDataForBottomView()
    }
    
    func handleSwitch(_ isOn: Bool, indexPath: Int) {
        guard let data = data else { return }
        
        if isOn {
            if countOfChoosenPromocodes < 2 {
                countOfChoosenPromocodes += 1
                applyDiscount(data.promocodes[indexPath])
            } else {
                errorMessage = "Вы не можете активировать более 2-х промокодов одновременно"
                isActiveCell = indexPath
            }
        } else {
            countOfChoosenPromocodes -= 1
            removeDiscount(data.promocodes[indexPath])
        }
    }
}

private extension OrderViewModel {
    
    func isDataCorrect() {
        if let data = data {
            if data.products.isEmpty {
                errorMessage = "На данный момент, заказов в корзине нет"
            }
            
            data.promocodes.forEach {
                if $0.active == true {
                    countOfChoosenPromocodes += 1
                    if countOfChoosenPromocodes > 2 {
                        countOfChoosenPromocodes = 2
                        errorMessage = "Было активировано более 2-х промокодов"
                    }
                }
            }
            
            data.products.forEach {
                if $0.price <= 0 {
                    errorMessage = "Цена заказов должна быть больше нуля"
                }
            }
            
            for dataProd in data.products {
                if dataProd.price < data.baseDiscount ?? 0 {
                    errorMessage = "Стартовая скидка не может быть больше чем цена"
                }
            }
        } else {
            errorMessage = "Не удалось получить данные"
        }
    }
    
    func setupDataForBottomView() {
        guard let data = data else { return }
        totalSumMain = data.products.reduce(0) { $0 + $1.price }
        fixedDiscount = data.baseDiscount ?? 0
        paymentDiscount = data.paymentDiscount ?? 0
        
        activePromocodes = data.promocodes.filter { $0.active }
        recalculateTotalSum()
    }
    
    func applyDiscount(_ promocode: Order.Promocode) {
        activePromocodes.append(promocode)
        recalculateTotalSum()
    }
    
    func removeDiscount(_ promocode: Order.Promocode) {
        activePromocodes.removeAll { $0.title == promocode.title }
        recalculateTotalSum()
    }
    
    func recalculateTotalSum() {
        let discountSum = activePromocodes.reduce(0) {
            $0 + (totalSumMain * Double($1.percent) / 100)
        }
        totalSum = totalSumMain - discountSum - fixedDiscount - paymentDiscount
    }
    
    func notifyUpdate() {
        let totalDiscount = activePromocodes.reduce(0) {
            $0 + (totalSumMain * Double($1.percent) / 100)
        }
        delegate?.didUpdateTotalSum(totalSum, totalDiscount: totalDiscount)
    }
}
