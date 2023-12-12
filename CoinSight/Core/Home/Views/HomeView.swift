//
//  HomeView.swift
//  CoinSight
//
//  Created by SinaVN on 8/19/1402 AP.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm : HomeViewModel
    @State private var showPortfolio :Bool = false // animate to right
    @State private var showPortfolioView : Bool = false // new sheet
    
    var body: some View {
        ZStack{
//            background layer
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView()
                        .environmentObject(vm)
                }
//            content layer
            
            VStack {
                
                homeHeader
                
                
                if vm.isLoading{
                    ProgressView()
                }else{
                    
                    HomeStatsView(showPortfolio: $showPortfolio)
                    
                    SearchBarView(textFieldText: $vm.searchText)
                    
                    columnTitles
                    
                    if !showPortfolio {
                       allCoinList
                        .transition(.move(edge: .leading))
                    }
                    if showPortfolio {
                        portfolioCoinList
                            .transition(.move(edge: .trailing))
                    }
                 
                    
                    
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


extension HomeView{
    
    //MARK: - home header
    
    private var homeHeader :some View{
        
        HStack {
            CircleButtonView(showPortfolio: $showPortfolio, iconName: showPortfolio ? "plus" :"info")
                .onTapGesture {
                    if showPortfolio{
                        showPortfolioView.toggle()
                    }
                }
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
                    withAnimation(.linear){
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    //MARK: - all coins list

    private var allCoinList : some View {
        List {
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingColumns: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
    }
    
    //MARK: - portfolio coins list
   
    private var portfolioCoinList : some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingColumns: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }.onDelete { index in
                let coin = vm.portfolioCoins[index.first ?? 0]
                vm.updatePortfolio(coin: coin, amount: 0.0)
            }
        }
        
        .listStyle(.plain)
    }
    
    //MARK: - column title
 
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
