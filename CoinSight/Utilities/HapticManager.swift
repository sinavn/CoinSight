//
//  HapticManager.swift
//  CoinSight
//
//  Created by Sina Vosough Nia on 11/19/1402 AP.
//

import Foundation
import SwiftUI

class HapticManager {
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification (type : UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
