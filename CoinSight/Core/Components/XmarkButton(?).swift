//
//  XmarkButton.swift
//  CoinSight
//
//  Created by SinaVN on 9/17/1402 AP.
//

import SwiftUI

struct XmarkButton: View {
   
    @Environment (\.presentationMode) var isPresented
    
    var body: some View {
        Button {
            isPresented.wrappedValue.dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
        }
        
        
    }
    
    struct XmarkButton_Previews: PreviewProvider {
        static var previews: some View {
            XmarkButton()
        }
    }
}
