//
//  StatisticModel.swift
//  CoinSight
//
//  Created by SinaVN on 9/7/1402 AP.
//

import Foundation

struct StatisticModel :Identifiable {
    let id = UUID().uuidString
    let title : String
    let value : String
    let percentageChange : Double?
    
    init(tile:String, value:String , percentageChange :Double? = nil) {
        self.title = tile
        self.value = value
        self.percentageChange = percentageChange
            }
}
