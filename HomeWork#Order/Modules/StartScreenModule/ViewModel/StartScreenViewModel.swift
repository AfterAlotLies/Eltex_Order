//
//  StartScreenViewModel.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 13.12.2024.
//

import Combine

final class StartScreenViewModel {
    private(set) var navigationSubscribtion = PassthroughSubject<ButtonIdentifier, Never>()
    
    func navigateToNextScreen(clickedButtonType: ButtonIdentifier) {
        navigationSubscribtion.send(clickedButtonType)
    }
}
