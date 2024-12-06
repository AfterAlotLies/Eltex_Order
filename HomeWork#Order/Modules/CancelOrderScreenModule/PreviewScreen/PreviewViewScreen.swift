//
//  PreviewViewScreen.swift
//  HomeWork#Order
//
//  Created by Vyacheslav Gusev on 05.12.2024.
//

import SwiftUI

struct PreviewViewScreen: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink {
                    CancelOrderView()
                } label: {
                    Text("Move to cancel order view")
                        .navigationTitle("")
                        .navigationBarTitleDisplayMode(.inline)
                }
                
                NavigationLink {
                    Text("Containers Order Screen")
                } label: {
                    Text("Move to Containers Order Screen")
                }
            }
            .padding()
        }
    }
}
