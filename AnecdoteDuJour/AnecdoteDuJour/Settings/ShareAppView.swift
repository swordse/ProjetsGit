//
//  ShareAppView.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 12/02/2023.
//

import SwiftUI

struct ShareAppView: View {
    
    @State private var showShareView = false
    
    var body: some View {
        ZStack {
            Color("background").ignoresSafeArea()
        VStack {
            MessageView(title: "Partagez Anecdote du Jour", message: "Pour faire connaitre Anecdote du jour, cliquez sur le lien ci-dessous") {
                Button {
                    showShareView.toggle()
                } label: {
                    HStack {
                        Image(systemName: "square.and.arrow.up").foregroundColor(.blue)
                        Text("Partagez").foregroundColor(.blue)
                    }
                    .padding()
                    //                .background(Color.blue).cornerRadius(10)
                }
            }
//            .padding()
            //            Button {
            //                showShareView.toggle()
            //            } label: {
            //                HStack {
            //                    Image(systemName: "square.and.arrow.up").foregroundColor(.white)
            //                    Text("Partagez").foregroundColor(.white)
            //                }
            ////                .padding()
            ////                .background(Color.blue).cornerRadius(10)
            //            }
        }
        .background { Color("background")}
    }
        .sheet(isPresented: $showShareView) {
            if let url = URL(string: "https://apps.apple.com/us/app/fabula/id6443920494") {
                ShareSheetView(activityItems: ["J'aime beaucoup cette application. Essaie-la.", url])
            }
        }
    }
}

struct ShareAppView_Previews: PreviewProvider {
    static var previews: some View {
        ShareAppView()
    }
}
