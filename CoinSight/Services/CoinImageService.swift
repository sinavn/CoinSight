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
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName : String
    
    
    init (coin : CoinModel){
        self.coin = coin
        self.imageName = coin.id
         getCoinImage()
    }
    
//    get images from local file manager
    private func getCoinImage (){
        if let savedImage = fileManager.getImage(folderName: folderName, imageName: imageName){
            image = savedImage
            
        }else{
            downloadCoinImages()
        }
    }
    
//    download images from internet
    private func downloadCoinImages (){
        guard let url = URL(string: coin.image) else {return}
            
            imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
                .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] returnedImages in
                    guard
                        let self = self ,
                        let downloadedImage = returnedImages
                        else {return}
                    self.image = returnedImages
                    self.imageSubscription?.cancel()
                    self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
                    
                })
        
    }
}
