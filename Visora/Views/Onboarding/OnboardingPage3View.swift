//
//  Created on November 9, 2025.
//

import SwiftUI

struct OnboardingPage3View: View {
    var body: some View {
        VStack(spacing: 0) {
            // Image at the top - extends to top edge
            Image("Onboarding3")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: UIScreen.main.bounds.height * 0.54)
                .clipShape(BottomRoundedRectangle(radius: 24))
            
            // Text content
            VStack(spacing: 24) {
                VStack(spacing: 4) {
                    Text("Your memories,")
                        .font(.custom("Montserrat", size: 34).weight(.black))
                        .foregroundColor(.textColor)
                    
                    HStack(spacing: 8) {
                        Text("beautifully")
                            .font(.custom("Montserrat", size: 34).weight(.black))
                            .foregroundColor(.textColor)
                        
                        ZStack(alignment: .bottom) {
                            Text("organized")
                                .font(.custom("Montserrat", size: 34).weight(.black))
                                .foregroundColor(Color.actionColor)
                            
                            CurvedUnderline()
                                .fill(Color.actionColor)
                                .frame(width: 140, height: 8)
                                .offset(y: 22)
                        }
                    }
                }
                .padding(.top, 40)
                
                Text("Track your travels on an interactive map\nand relive your adventures through a\nvisual timeline of analyzed moments")
                    .font(.custom("Nunito Sans", size: 17))
                    .foregroundColor(.subTextColor)
                    .multilineTextAlignment(.center)
                    .padding(.top, 16)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
        .background(Color.white)
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    OnboardingPage3View()
}
