//
//  SingleWordView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 29/06/2022.
//

import SwiftUI

struct SingleWordView: View {
    
    @Environment(\.presentationMode) var presentationMode

    @StateObject var viewModel = SingleWordViewModel()
    @Binding var wordString: String
    
    var body: some View {
        NavigationView {
        ZStack {
            Color.background
                .ignoresSafeArea()
            ScrollView {
                WordView(word: $viewModel.specificWord)
                    .padding()
            }
        }
        }.onAppear {
            viewModel.getSpecificWord(word: wordString)
        }
        .alert(isPresented: $viewModel.errorOccured) {
            Alert(title: Text("Erreur"), message: Text("Une erreur est survenue. Veuillez réessayer ultérieurement."), dismissButton: .default(Text("OK")))
        }
    }
}

struct SingleWordView_Previews: PreviewProvider {
    static var previews: some View {
        SingleWordView(wordString: .constant("Bob"))
    }
}
