//
//  CommentView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 22/06/2022.
//

import SwiftUI

struct SubmitProposalView: View {
    
    @Binding var showUserAccount: Bool
    @StateObject var viewModel = SubmitProposalViewModel()
    
    @AppStorage(Keys.currentUserSaved) var user: Data = Data()
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                if !user.isEmpty {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            SubmitForm(image: ImageSubmitForm.category, categoryName: "Catégorie")
                            
                            Picker("Categorie", selection: $viewModel.selectedCategory) { ForEach(SelectedCategory.allCases, id: \.self) { category in
                                Text(category.rawValue)
                            }
                            }
                            .pickerStyle(.segmented)
                            .frame(height: 50)
                            .cornerRadius(20)
                            .clipped()
                            
                            switch viewModel.selectedCategory {
                            case .Anecdote:
                                AnecdoteProposalView(source: $viewModel.source, anecdote: $viewModel.anecdote)
                                    .onTapGesture {
                                        hideKeyboard()
                                    }
                            case .Citation:
                                QuoteProposalView(author: $viewModel.author, quoteSubmitted: $viewModel.quote)
                                    .onTapGesture {
                                        hideKeyboard()
                                    }
                            case .MotDuJour:
                                WordProposalView(word: $viewModel.word, definition: $viewModel.definition)
                                    .onTapGesture {
                                        hideKeyboard()
                                    }
                            }
                            Button {
                                viewModel.saveProposal()
                            } label: {
                                ButtonView(text: !user.isEmpty ? "SOUMETTRE" : "VOUS DEVEZ VOUS CONNECTER")
                            }
                            .buttonStyle(.plain)
                            .disabled(viewModel.buttonIsDisable || user.isEmpty)
                            Text("En soumettant une proposition vous acceptez les règles de soumission (consultables dans les préférences).")
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .multilineTextAlignment(.center)
                        }.padding()
                    }
                    
                }
                else {
                    VStack(spacing: 80) {
                        Text("Pour soumettre une proposition, vous devez vous connecter.")
                            .font(.title2)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                        
                        Button {
                            showUserAccount = true
                        } label: {
                            ButtonView(text: "ACCEDEZ A LA PAGE DE CONNEXION")
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .onChange(of: viewModel.selectedCategory, perform: { newValue in
                viewModel.updateButtonState()
            })
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text(viewModel.alertMessage.title), message: Text(viewModel.alertMessage.message), dismissButton: .default(Text("OK")))
            }
            .navigationTitle("Proposition")
        }
    }
}

struct SubmitProposalView_Previews: PreviewProvider {
    static var previews: some View {
        SubmitProposalView(showUserAccount: .constant(false))
    }
}
