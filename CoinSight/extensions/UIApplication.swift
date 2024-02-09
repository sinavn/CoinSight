//
//  UIApplication.swift
//  CoinSight
//
//  Created by SinaVN on 9/6/1402 AP.
//

import Foundation
import SwiftUI

extension UIApplication{
    func endEditing (){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
