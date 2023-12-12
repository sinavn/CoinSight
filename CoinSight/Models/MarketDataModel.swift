//
//  MarketDataModel.swift
//  CoinSight
//
//  Created by SinaVN on 9/15/1402 AP.
//

import Foundation

/*
 url : https://api.coingecko.com/api/v3/global
 
 */

struct GlobalData: Codable {
    let data: MarketDataModel?
}
struct MarketDataModel: Codable {
    
//    lines below are not needed for now
    
//    let activeCryptocurrencies, upcomingIcos, ongoingIcos, endedIcos: Double?
//    let markets: Double?
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double?

    enum CodingKeys: String, CodingKey {
//        case activeCryptocurrencies = "active_cryptocurrencies"
//        case upcomingIcos = "upcoming_icos"
//        case ongoingIcos = "ongoing_icos"
//        case endedIcos = "ended_icos"
//        case markets
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    var marketCap : String {
        if let item = totalMarketCap.first(where: {$0.key == "usd"}){
            return "$"+item.value.asAbbreviated()
        }else{
            return ""
        }
    }
    var marketVolume : String {
        if let item = totalVolume.first(where: {$0.key == "usd"}) {
            return "$"+item.value.asAbbreviated()
        }else{
            return ""
        }
    }
    var btcDominance : String {
        if let item = marketCapPercentage.first(where: {$0.key == "btc"}){
            return "\(item.value.asPercentString())"
        }else{
            return ""
        }
    }
}
