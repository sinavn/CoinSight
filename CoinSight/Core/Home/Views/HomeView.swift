//
//  HomeView.swift
//  CoinSight
//
//  Created by SinaVN on 8/19/1402 AP.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm : HomeViewModel
    @State private var showPortfolio :Bool = false
    
    var body: some View {
        ZStack{
//            background layer
            Color.theme.background
                .ignoresSafeArea()
//            content layer
            VStack {
                homeHeader
                
                columnTitles
                
                if !showPortfolio {
                   allCoinList
                    .transition(.move(edge: .leading))
                }
                if showPortfolio {
                    portfolioCoinList
                        .transition(.move(edge: .trailing))
                }
             
                
                Spacer(minLength: 0)
            }
        }
    }
}

//MARK: - preview

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .toolbar(.hidden )
        }
        .environmentObject(dev.homeVM)
    }
}
//MARK: - home header

extension HomeView{
    private var homeHeader :some View{
        
        HStack {
            CircleButtonView(showPortfolio: $showPortfolio, iconName: showPortfolio ? "plus" :"info")
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none)
            Spacer()
            CircleButtonView(showPortfolio: .constant(true), iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()){
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinList : some View {
        List {
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingColumns: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
    }
    
    private var portfolioCoinList : some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingColumns: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
    }
    private var columnTitles : some View {
        HStack{
            Text("coin")
            Spacer()
            if showPortfolio{
            Text("Holdings")
            }
            Text("Price")
                .frame(width: UIScreen.main.bounds.width / 3.5 ,alignment: .trailing)

        }
        .font(.caption)
        .foregroundColor(Color.theme.secondary)
        .padding(.horizontal)
    }
}
