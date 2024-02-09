//
//  PortfolioDataService.swift
//  CoinSight
//
//  Created by SinaVN on 9/20/1402 AP.
//

import Foundation
import CoreData

class PortfolioDataService {
    
    @Published var savedEntity : [PortfolioEntity] = []
    private let container : NSPersistentContainer
    
    
    init() {
        container = NSPersistentContainer(name: "PortfolioContainer")
        container.loadPersistentStores {_, error in
            if let error = error {
                print("error loading PortfolioContainer \(error)")
            }
            self.getPortfolio()
        }
    }
    
    
    
    //MARK: - PUBLIC
    
    func updatePortfolio (coin : CoinModel , newAmount:Double){
        
        if let entity = savedEntity.first(where: {$0.coinID == coin.id}){
            if newAmount > 0 {
                update(entity: entity, newAmount: newAmount)
            }else{
                delete(entity: entity)
            }
        }
        else{
            addPortfolio(coin: coin, amount: newAmount)
        }
        
    }
    
    //MARK: - PRIVATE
        private func getPortfolio (){
        let request = NSFetchRequest<PortfolioEntity>(entityName: "PortfolioEntity")
        do{
            savedEntity = try container.viewContext.fetch(request)
        }catch let error{
            print("error fetching PortfolioEntity \(error)")
        }
    }
    private func addPortfolio (coin : CoinModel , amount : Double){
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        save()
    }
    private func update (entity:PortfolioEntity , newAmount : Double){
        entity.amount = newAmount
        save()
    }
    
    private func delete (entity:PortfolioEntity){
        container.viewContext.delete(entity)
        save()
    }
    
    private func save (){
        do{
            try container.viewContext.save()
        }catch let error{
            print("error saving data to coreData \(error)")
        }
        getPortfolio()
    }
}
