//
//  StatsView.swift
//  CoinSight
//
//  Created by SinaVN on 9/7/1402 AP.
//

import SwiftUI

struct StatsView: View {
    let stat : StatisticModel
    
    var body: some View {
        VStack {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(Color.theme.secondary)
            Text(stat.value)
                .font(.headline)
                .foregroundColor(Color.theme.accent)
            HStack (spacing: 1){
                
                Image(systemName: "arrowtriangle.up.fill")
                    .font(.caption)
                    .rotationEffect(Angle(degrees:(stat.percentageChange ?? 0) >= 0 ? 0 : 180 ))
                
                Text(stat.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                    .bold()
            }
            .foregroundColor((stat.percentageChange ?? 0) > 0 ? Color.green : Color.red)
            .opacity(stat.percentageChange == nil ? 0.0 : 1.0)
          
            
        }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView(stat: dev.stat1)
    }
}
