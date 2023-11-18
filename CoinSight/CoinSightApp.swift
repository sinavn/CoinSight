//
//  CoinSightApp.swift
//  CoinSight
//
//  Created by SinaVN on 8/19/1402 AP.
//

import SwiftUI

@main
struct CoinSightApp: App {
    
    @StateObject private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .toolbar(.hidden)
            }
            .environmentObject(vm)
        }
    }
}
