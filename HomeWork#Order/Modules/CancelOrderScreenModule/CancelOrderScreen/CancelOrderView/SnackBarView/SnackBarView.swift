//
//  SnackBarView.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 06.12.2024.
//

import SwiftUI

struct SnackBarView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .frame(maxWidth: 205, maxHeight: 40)
                .cornerRadius(50)
                .foregroundStyle(Color.black.opacity(0.5))
            Text("Заказ успешно отменен")
                .foregroundStyle(Color.white)
                .font(Font.system(size: 14))
                .padding()
        }
    }
}
