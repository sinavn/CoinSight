//
//  HomeViewModel.swift
//  CoinSight
//
//  Created by SinaVN on 8/22/1402 AP.
//

import Foundation
import Combine

class HomeViewModel : ObservableObject {
    
    @Published var stats :[StatisticModel] = []
    @Published var allCoins : [CoinModel] = []
    @Published var portfolioCoins : [CoinModel] = []
    @Published var isLoading : Bool = false
    @Published var searchText : String = ""
    
    var cancellables = Set<AnyCancellable>()
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    
    init() {
     addSubscribers()
    isLoading = true
    }
    func addSubscribers(){
        
        // update all coins
        coinDataService.$allCoins
            .sink {[weak self] returnedCoins in
                self?.allCoins = returnedCoins
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
        //filtered coins
        coinDataService.$allCoins
            .combineLatest($searchText)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] returnedFilteredCoin in
                self?.allCoins = returnedFilteredCoin
            }
            .store(in: &cancellables)
        
        //update market stats
        marketDataService.$marketData
            .map(mapGlobalMarketData)
            .sink { [weak self] ReturnedmarketData in
                self?.stats = ReturnedmarketData
            }
            .store(in: &cancellables)
        
        //update portfolio from coreData
        $allCoins
            .combineLatest(portfolioDataService.$savedEntity)
            .map(mapPortfolioCoins)
            .sink {[weak self] returnedCoins in
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio (coin:CoinModel , amount : Double){
        portfolioDataService.updatePortfolio(coin: coin, newAmount: amount)
    }
    
    private func filterCoins(startingCoins : [CoinModel] , text : String)-> [CoinModel]{
            guard !text.isEmpty else{
                return startingCoins
            }
            let lowerCasedText = text.lowercased()
            
            return startingCoins.filter { coin ->Bool in
                return coin.name.lowercased().contains(lowerCasedText) ||
                coin.symbol.lowercased().contains(lowerCasedText) ||
                coin.id.lowercased().contains(lowerCasedText)
            }
    }
    
    
    private func mapGlobalMarketData (marketDataModel:MarketDataModel?)->[StatisticModel]{
        var stats : [StatisticModel] = []
        
        guard let data = marketDataModel else {return stats}
        
        let TotalMarketCap = StatisticModel(tile: "Total market cap", value: data.marketCap ,percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(tile: "24H volume", value: data.marketVolume )
        let btcDominance = StatisticModel(tile: "BTC dominance", value: data.btcDominance )
        let portfolio = StatisticModel(tile: "Pertfolio Value", value:  "0.00",percentageChange: 0.00)
        
        stats.append(contentsOf: [TotalMarketCap,volume,btcDominance,portfolio])
        return stats
    }
    
    
    private func mapPortfolioCoins (coinModels:[CoinModel] , portfolioEntities : [PortfolioEntity])->[CoinModel]{
       
        coinModels
            .compactMap { coin in
                guard let entity = portfolioEntities.first(where: {$0.coinID == coin.id})
                else{
                    return nil
                }
                return coin.updateHoldings(amount: entity.amount)
            }
    }
    
    	
}
