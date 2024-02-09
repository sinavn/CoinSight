//
//  HomeStatsView.swift
//  CoinSight
//
//  Created by SinaVN on 9/7/1402 AP.
//

import SwiftUI

struct HomeStatsView: View {
    @EnvironmentObject private var vm : HomeViewModel
    
    @Binding var showPortfolio : Bool
    var body: some View {
        HStack{
            ForEach(vm.stats) { stat in
                StatsView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width
               ,alignment:showPortfolio ? .trailing :.leading )
    }
}

struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatsView(showPortfolio: .constant(false))
            .environmentObject(dev.homeVM)
    }
}
