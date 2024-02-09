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
    @Published var isReloading : Bool = false
    @Published var searchText : String = ""
    @Published var sortOption : SortOption = .rank
    var cancellables = Set<AnyCancellable>()
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    
    enum SortOption {
    case rank , rankReversed , holdings , holdingsReversed , price , priceReversed , topGainers , topLosers
    }
    
    init() {
     addSubscribers()
    isLoading = true
    }
    
    func addSubscribers(){
        

        //updated and filtered coins
        $searchText
            .combineLatest(coinDataService.$allCoins , $sortOption)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterAndSortCoins)
            .sink { [weak self] returnedFilteredCoin in
                guard let self = self else{return}
                self.allCoins = returnedFilteredCoin
                self.isLoading = false
            }
            .store(in: &cancellables)
        
        //update portfolio from coreData
        $allCoins
            .combineLatest(portfolioDataService.$savedEntity)
            .map(mapPortfolioCoins)
            .sink {[weak self] returnedCoins in
                guard let self = self else{return}
                let sortedPortfolioCoins = sortCoinsIfNeeded(sort: sortOption, coins: returnedCoins)
                self.portfolioCoins = sortedPortfolioCoins
            }
            .store(in: &cancellables)
        
        //update market stats
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] ReturnedmarketData in
                guard let self = self else {return}
                self.stats = ReturnedmarketData
                self.isReloading = false
            }
            .store(in: &cancellables)
        
       
    }
    
    func updatePortfolio (coin:CoinModel , amount : Double){
        portfolioDataService.updatePortfolio(coin: coin, newAmount: amount)
    }
    
    // reload data and suscribers
    func reloadData (){
        isReloading = true
        coinDataService.getCoins()
        marketDataService.getMarketData()
        HapticManager.notification(type: .success)
    }
    
    private func filterAndSortCoins(text:String , coins:[CoinModel] , sort:SortOption)->[CoinModel]{
        var updatedCoins = filterCoins(text: text, startingCoins: coins)
        sortCoins(sort: sort, coin: &updatedCoins)
        return updatedCoins
        
    }
    
    
    // filter coins by search text
    private func filterCoins(text:String , startingCoins:[CoinModel] )->[CoinModel]{
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
    //sort coins
    private func sortCoins (sort : SortOption , coin : inout [CoinModel]){
        switch sort {
        case .rank , .holdings:
            coin.sort(by: {$0.rank < $1.rank})
        case .rankReversed , .holdingsReversed:
            coin.sort(by: {$0.rank > $1.rank})
        case .price:
            coin.sort(by: {$0.currentPrice < $1.currentPrice})
        case .priceReversed:
            coin.sort(by: {$0.currentPrice > $1.currentPrice})
        case .topGainers:
            coin.sort(by: {$0.priceChangePercentage24H ?? 0.0 > $1.priceChangePercentage24H ?? 0.0})
        case .topLosers:
            coin.sort(by: {$0.priceChangePercentage24H ?? 0.0 < $1.priceChangePercentage24H ?? 0.0})

        }
    }
    //sort coins if needed
    private func sortCoinsIfNeeded (sort : SortOption , coins : [CoinModel]) -> [CoinModel]{
        switch sort {
        case .holdings:
            return coins.sorted(by: {$0.currentHoldingsValue > $1.currentHoldingsValue})
        case .holdingsReversed:
            return coins.sorted(by: {$0.currentHoldingsValue < $1.currentHoldingsValue})
        default :
            return coins
        }
    }
    private func mapGlobalMarketData (marketDataModel:MarketDataModel? , portfolioCoins: [CoinModel])->[StatisticModel]{
        var stats : [StatisticModel] = []
        
        guard let data = marketDataModel else {return stats}
        
        let portfolioValue =
        portfolioCoins
            .map({$0.currentHoldingsValue})
            .reduce(0,+)
        
        let previousValue = portfolioCoins
            .map { coin -> Double in
                let currentValue = coin.currentHoldingsValue
                let currentPriceChange = coin.priceChangePercentage24H ?? 0 / 100
                return currentValue / (1 + currentPriceChange)
            }
            .reduce(0, +)
        
        let portfolio24ChangePercent = ((portfolioValue - previousValue ) / previousValue) 
        
        let TotalMarketCap = StatisticModel(tile: "Total market cap", value: data.marketCap ,percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(tile: "24H volume", value: data.marketVolume )
        let btcDominance = StatisticModel(tile: "BTC dominance", value: data.btcDominance )
        let portfolio = StatisticModel(tile: "Pertfolio Value", value:  portfolioValue.asCurrencyWith2Decimals() ,percentageChange: portfolio24ChangePercent)
        
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
