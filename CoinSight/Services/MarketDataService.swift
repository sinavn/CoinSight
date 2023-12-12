//
//  MarketDataService.swift
//  CoinSight
//
//  Created by SinaVN on 9/15/1402 AP.
//

import Foundation
import Combine

class MarketDataService {

    @Published var marketData : MarketDataModel? = nil
    var marketDataSubscription:AnyCancellable?
    init() {
        getMarketData()
    }

    private func getMarketData(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global")
        else {return}

        marketDataSubscription = NetworkingManager.download(url: url)

            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedGlobalData in
                self?.marketData = returnedGlobalData.data
                self?.marketDataSubscription?.cancel()
            })
    }
  
    }

