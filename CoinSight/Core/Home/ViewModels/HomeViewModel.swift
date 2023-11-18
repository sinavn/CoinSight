//
//  HomeViewModel.swift
//  CoinSight
//
//  Created by SinaVN on 8/22/1402 AP.
//

import Foundation
import Combine

class HomeViewModel : ObservableObject {
    @Published var allCoins : [CoinModel] = []
    @Published var portfolioCoins : [CoinModel] = []
    
    var cancellables = Set<AnyCancellable>()
    
    private let coinService = CoinDataService()
    
    init() {
     addSubscribers()
    }
    func addSubscribers(){
        coinService.$allCoins
            .sink {[weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
}
