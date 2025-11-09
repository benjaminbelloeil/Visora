//
//  PrimaryButton.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .cornerRadius(12)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        PrimaryButton(title: "Get Directions") {
            print("Button tapped")
        }
        
        PrimaryButton(title: "Save") {
            print("Save tapped")
        }
    }
    .padding()
}
