//
//  CoinImageService.swift
//  CoinSight
//
//  Created by SinaVN on 8/27/1402 AP.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    @Published var image : UIImage? = nil
    private var imageSubscription : AnyCancellable?
    private let coin : CoinModel
    
    init (coin : CoinModel){
        self.coin = coin
        getCoinImages()
    }
    
    private func getCoinImages (){
        guard let url = URL(string: coin.image) else {return}
            
            imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
                .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedCoins in
                    self?.image = returnedCoins
                    self?.imageSubscription?.cancel()
                })
        
    }
}
