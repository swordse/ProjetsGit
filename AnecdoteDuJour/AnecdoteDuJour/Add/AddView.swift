//
//  AddView.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 31/01/2023.
//

import SwiftUI

struct AddView: View {
    
//    var proxy : GeometryProxy
    
    var body: some View {
        
        VStack(spacing: 10) {
            Text("Publicité")
            BannerAd(unitID: "ca-app-pub-3940256099942544/2934735716")
                .padding([.horizontal, .bottom])
        }
        .frame(height: 100)
        .padding()
        .padding(.bottom, 30)
        .background(Color("cellBackground"))
//        .cornerRadius(10)
//        .padding(.horizontal)
        
    }
}

//struct AddView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddView(proxy: GeometryProxy)
//    }
//}
