//
//  PortfolioView.swift
//  CoinSight
//
//  Created by SinaVN on 9/17/1402 AP.
//

import SwiftUI

struct PortfolioView: View {
    
    @Environment (\.dismiss) var dismiss
    
    @EnvironmentObject var vm : HomeViewModel
    @State var selectedCoin : CoinModel? = nil
    @State var quantityText : String = ""
    @State var showCheckMark : Bool = false
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(alignment:.leading,spacing: 0){
                    
                    SearchBarView(textFieldText: $vm.searchText)
                    
                    coinLogoList
                    
                    if selectedCoin != nil {
                        PortfolioInputSection
                    }
                    
                }
            }
            .navigationTitle("portfolio")
            
            // xmark button
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.headline)
                            .foregroundColor(Color.theme.secondary)
                    }
                    
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                   trailingNavBarButton
                }
            })
            .onChange(of: vm.searchText) { value in
                if value == "" {
                    deSelectCoin()
                }
            }
            
        }
        
    }
    
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}

extension PortfolioView {
    //MARK: - coin logo list
    
    private var coinLogoList : some View {
        ScrollView(.horizontal,showsIndicators: false){
            LazyHStack(spacing:10){
                ForEach(vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeOut) {
                                selectedCoin = coin
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear,lineWidth: 1)
                        )
                }
                
            }
            .padding(.vertical , 4)
            .padding(.leading)
        }
    }
    private func getCurrentValue ()->Double{
        if let quantity = Double(quantityText){
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    private var PortfolioInputSection : some View{
        VStack (spacing: 20){
            HStack{
                Text("current price of \(selectedCoin?.symbol ?? "") ")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimala() ?? "")
            }
            Divider()
            HStack {
                Text("amount holding:")
                Spacer()
                TextField("Ex: 2.3", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack{
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith6Decimala())
            }
        }
        .animation(.default, value:0.2)
        .padding()
    }
    private var trailingNavBarButton :some View {
        HStack(spacing : 10){
            Image(systemName: "checkmark")
                .opacity(showCheckMark ? 1.0 : 0.0)
         Button(action: {
             saveButtonPressed()
         }, label: {
             Text("save".uppercased())
         })
         .opacity(
            selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText) ?
            1.0 : 0.0
         )

        }
    }
    private func saveButtonPressed (){
        guard let coin = selectedCoin ,
              let amount = Double(quantityText)
                else {return}
        
        //save to portfolio
        vm.updatePortfolio(coin: coin, amount: amount)
        //show checkmark
        withAnimation {
            showCheckMark = true
            deSelectCoin()
        }
        //hide keyBoard
        UIApplication.shared.endEditing()
        
        //hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation{
                showCheckMark = false
            }
        }
    }
    private func deSelectCoin (){
        selectedCoin = nil
        vm.searchText = ""
    }
}
