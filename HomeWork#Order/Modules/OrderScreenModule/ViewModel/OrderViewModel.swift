//
//  OrderViewModel.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 22.10.2024.
//

import Foundation

protocol OrderViewModelDelegate: AnyObject {
    func setData(_ data: Order)
    func showAlert(_ alertTitle: String, _ alertMessage: String)
    func countOfChoosenPromocodesDidChanged(_ count: Int)
    func isActiveCellDidChanged(_ index: Int)
    func didUpdateTotalSum(_ totalSum: Double, totalDiscount: Double)
    func didHidePromocode(_ data: Order, isActive: Bool)
    func showController(_ data: Order)
    func showSnackView()
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
            delegate?.showAlert(ErrorMessages.titleAlert, errorMessage)
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
    
    private var totalSum: Double = 0.0 {
        didSet {
            notifyUpdate()
        }
    }
    
    private var totalSumMain: Double = 0.0
    private var activePromocodes: [Order.Promocode] = []
    private var updatedPromocodes: [Order.Promocode] = []
    private var displayedPromocodes: [Order.Promocode] = []
    private var fixedDiscount: Double = 0.0
    private var paymentDiscount: Double = 0.0
    private var isPromocodesHidden: Bool = false
    
    weak var delegate: OrderViewModelDelegate?
    
    func udpateOrderData(_ data: Order) {
        self.data = data
        updatedPromocodes = data.promocodes
        countOfChoosenPromocodes = 0
        isDataCorrect()
        setupDataForBottomView()
        delegate?.showSnackView()
    }
    
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
                                                             active: false)],
                           products: [Order.Product.init(price: 30000.0, title: "Продукты"),
                                      Order.Product(price: 5000.0, title: "Chto-to")],
                           availableForActive: [Order.Promocode.init(title: "123",
                                                                     percent: 2,
                                                                     endDate: Date(),
                                                                     info: nil,
                                                                     active: false),
                                                Order.Promocode(title: "321",
                                                                percent: 4,
                                                                endDate: Date(),
                                                                info: nil,
                                                                active: false)],
                           paymentDiscount: 1000.0,
                           baseDiscount: 1000.0))
        self.data = order
        updatedPromocodes = order.promocodes
        self.displayedPromocodes = updatedPromocodes
        isDataCorrect()
        setupDataForBottomView()
    }
    
    func handleSwitch(_ isOn: Bool, indexPath: Int) {
        guard indexPath < displayedPromocodes.count else { return }
        print(countOfChoosenPromocodes)
        let promocode = displayedPromocodes[indexPath]
        if let updatedIndex = updatedPromocodes.firstIndex(where: { $0.title == promocode.title }) {
            updatedPromocodes[updatedIndex].active = isOn
            displayedPromocodes[indexPath].active = isOn
            if isOn {
                if countOfChoosenPromocodes < 2 {
                    countOfChoosenPromocodes += 1
                    applyDiscount(displayedPromocodes[indexPath])
                } else {
                    errorMessage = ErrorMessages.moreThanTwoCurrentActivatedPromocodes
                    updatedPromocodes[updatedIndex].active = false
                    displayedPromocodes[indexPath].active = false
                    isActiveCell = indexPath
                }
            } else {
                countOfChoosenPromocodes -= 1
                removeDiscount(displayedPromocodes[indexPath])
            }
        }
    }
    
    func hidePromocodesAction() {
        guard var data = data else { return }

        if isPromocodesHidden {
            displayedPromocodes = updatedPromocodes
            isPromocodesHidden = false
        } else {
            let activePromocodes = updatedPromocodes.filter { $0.active }
            
            switch activePromocodes.count {
                case 2:
                    let inactivePromocodes = updatedPromocodes.filter { !$0.active }.prefix(1)
                    displayedPromocodes = Array(activePromocodes.prefix(2)) + Array(inactivePromocodes)

                case 1:
                    let inactivePromocodes = updatedPromocodes.filter { !$0.active }.prefix(2)
                    displayedPromocodes = [activePromocodes.first!] + Array(inactivePromocodes)

                default:
                    displayedPromocodes = Array(updatedPromocodes.prefix(3))
            }
            
            isPromocodesHidden = true
        }
        data.promocodes = displayedPromocodes
        delegate?.didHidePromocode(data, isActive: isPromocodesHidden)
        recalculateTotalSum()
    }
    
    
    func showNextController() {
        guard let data = data else { return }
        delegate?.showController(data)
    }
    
}

private extension OrderViewModel {
    
    func isDataCorrect() {
        if let data = data {
            if data.products.isEmpty {
                errorMessage = ErrorMessages.emptyProducts
            }
            
            data.promocodes.forEach {
                if $0.active == true {
                    countOfChoosenPromocodes += 1
                    if countOfChoosenPromocodes > 2 {
                        countOfChoosenPromocodes = 2
                        errorMessage = ErrorMessages.invalidCountActivatedPromocodes
                    }
                }
            }
            
            data.products.forEach {
                if $0.price <= 0 {
                    errorMessage = ErrorMessages.invalidProductsCost
                }
            }
            
            for dataProd in data.products {
                if dataProd.price < data.baseDiscount ?? 0 {
                    errorMessage = ErrorMessages.invalidBaseDiscount
                }
            }
        } else {
            errorMessage = ErrorMessages.cantGetData
        }
    }
    
    func setupDataForBottomView() {
        guard let data = data else {
            errorMessage = ErrorMessages.cantGetProductsData
            return
        }
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
