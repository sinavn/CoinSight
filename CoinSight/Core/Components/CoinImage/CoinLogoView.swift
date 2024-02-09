//
//  CoinLogoView.swift
//  CoinSight
//
//  Created by SinaVN on 9/17/1402 AP.
//

import SwiftUI

struct CoinLogoView: View {
    let coin:CoinModel
    var body: some View {
        VStack {
            CoinImageView(coin: coin)
                .frame(width: 50,height: 50)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(coin.name)
                .font(.caption)
                .foregroundColor(Color.theme.secondary)
                .lineLimit(2)
                .minimumScaleFactor(0.6)
                .multilineTextAlignment(.center)
        }
        
    }
}

struct CoinLogoView_Previews: PreviewProvider {
    static var previews: some View {
        CoinLogoView(coin: dev.coin)
            .previewLayout(.sizeThatFits)
    }
}
