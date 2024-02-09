//
//  CoinRowView.swift
//  CoinSight
//
//  Created by SinaVN on 8/20/1402 AP.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin :CoinModel
    let showHoldingColumns : Bool
    
    var body: some View {
        HStack(spacing: 0){
           leftColumn
            
            Spacer(minLength: 1)
            
            if showHoldingColumns{
             centerColumn
            }
            
            rightColumn
        }
        .font(.subheadline)
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoinRowView(coin: dev.coin, showHoldingColumns: true)
            .previewLayout(.sizeThatFits)
    }
        
}
extension CoinRowView {
    //MARK: - left column

    private var leftColumn: some View{
        HStack{
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondary)
                .frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30,height: 30)
            Text("\(coin.symbol)")
                .padding(.horizontal,6)
                .foregroundColor(Color.theme.accent)
                .lineLimit(1)
            Text("\(coin.name)")
                .frame(width: 60 , alignment: .leading)
                .lineLimit(3)
                .minimumScaleFactor(0.7)
                .font(.caption)
                .foregroundColor(Color.theme.secondary)

        }
        .scaledToFit()
        .fixedSize()
        
    }
        
    //MARK: - center column
    
    private var centerColumn : some View {
        VStack(alignment: .trailing){
            Text(coin.currentHoldingsValue.asCurrencyWith6Decimala())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
                
        }
        .foregroundColor(Color.theme.accent)
    }
        

    //MARK: - right column
    
    private var rightColumn :some View{
        VStack(alignment: .trailing){
            Text(coin.currentPrice.asCurrencyWith6Decimala())
                .bold()
                .foregroundColor(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "0")
                .foregroundColor((coin.priceChangePercentage24H ?? 0 ) >= 0 ?
                                 Color.theme.green :
                                    Color.theme.red)
        }

        .frame(width: UIScreen.main.bounds.width / 4 ,alignment: .trailing)
    }
}
