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
                    withAnimation(.smooth){
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
    private var portfolioCoinList: some View {
        NavigationView {
            List {
                ForEach(vm.portfolioCoins) { coin in
                    CoinRowView(coin: coin, showHoldingColumns: true)
                        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                }
                .onDelete { indexSet in
                    if let index = indexSet.first {
                        let coin = vm.portfolioCoins[index]
                        vm.updatePortfolio(coin: coin, amount: 0.0)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                   EditButton()
                        .foregroundColor(Color.theme.accent)
                }
            }
        }
        .font(.footnote)
        .background(Color.theme.background)
        .listStyle(.plain)
    }
    //MARK: - column title
 
    private var columnTitles : some View {
        HStack{
            HStack{
                Text("coin")
                Image(systemName: "chevron.down")
                    .opacity(vm.sortOption == .rank || vm.sortOption == .rankReversed ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.5)) {
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed:.rank
                }
            }
            
            Spacer()
            if showPortfolio{
                HStack{
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity(vm.sortOption == .holdings || vm.sortOption == .holdingsReversed ? 1.0 : 0.0)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed:.holdings
                    }
                }
            
            }
            HStack{
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity(vm.sortOption == .price || vm.sortOption == .priceReversed ? 1.0 : 0.0)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))

            }
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.5)) {
                    vm.sortOption = vm.sortOption == .price ? .priceReversed:.price
                }
            }
                .frame(width: UIScreen.main.bounds.width / 3.5 ,alignment: .trailing)
            
            Button(action: {
                withAnimation(.smooth(duration: 2.0)) {
                    vm.reloadData()
                }
            }, label: {
                Image(systemName: "goforward")
                    .rotationEffect(Angle(degrees: vm.isReloading ? 360 : 0))
            })
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondary)
        .padding(.horizontal)
    }
}
