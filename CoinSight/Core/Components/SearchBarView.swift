//
//  SearchBarView.swift
//  CoinSight
//
//  Created by SinaVN on 9/5/1402 AP.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var textFieldText : String
    var body: some View {
        HStack{
           Image(systemName: "magnifyingglass")
                .foregroundColor(
                    textFieldText.isEmpty ? Color.theme.secondary : Color.theme.accent)
            TextField("Search by name or symbol...", text: $textFieldText)
                .foregroundColor(Color.theme.accent)
                .autocorrectionDisabled()
                .overlay(Image(systemName: "xmark.circle.fill")
                    .foregroundColor(Color.theme.accent)
                    .opacity(textFieldText.isEmpty ? 0.0 : 1.0)
                         ,alignment: .trailing)
                .onTapGesture {
                    UIApplication.shared.endEditing()

                    withAnimation() {
                        textFieldText = ""
                    }
                }
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.background)
                .shadow(color: Color.theme.accent.opacity(0.20), radius: 15))
        .padding()
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(textFieldText: .constant(""))
    }
}
