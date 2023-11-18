//
//  CircleButtonView.swift
//  CoinSight
//
//  Created by SinaVN on 8/19/1402 AP.
//

import SwiftUI

struct CircleButtonView: View {
    
    @Binding var showPortfolio :Bool
    
    let iconName :String
    var body: some View {
       Image(systemName:iconName)
            .font(.headline)
            .foregroundColor(Color.theme.accent)
            .frame(width: 50,height: 50)
            .background(
                Circle()
                    .foregroundColor(Color.theme.background)
            )
            .shadow(color: Color.theme.accent.opacity(0.25), radius:showPortfolio ? 10 : 0 )
            .padding()
        
    }
}

struct CircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        
        CircleButtonView(showPortfolio: .constant(false), iconName: "heart.fill")
            .previewLayout(.sizeThatFits)
    }
}
