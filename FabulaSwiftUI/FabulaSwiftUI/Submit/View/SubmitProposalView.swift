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
    @State private var acceptBoxIsCheck = false
    
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
                            HStack {
                                Spacer()
                                Button {
                                    acceptBoxIsCheck.toggle()
                                } label: {
                                    Image(systemName: acceptBoxIsCheck ? "checkmark.square" : "square")
                                        .foregroundColor(.white)
                                }
                                Text("J'accepte les règles de soumission.")
                                Spacer()
                            }.padding(.vertical, 10)
                            Button {
                                viewModel.saveProposal()
                                acceptBoxIsCheck.toggle()
                            } label: {
                                ButtonView(text: !user.isEmpty ? "SOUMETTRE" : "VOUS DEVEZ VOUS CONNECTER")
                            }
                            .buttonStyle(.plain)
                            .disabled(!(viewModel.buttonIsEnable && acceptBoxIsCheck))
                            
                            Button {
                                let stringUrl = "https://www.sites.google.com/view/appfabula/accueil/règles-de-soumission"
                                let encoded = stringUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
                                
                                let url = URL(string: encoded!)
                                UIApplication.shared.open(url!)
                            } label: {
                                Text("Consultez les règles.")
                                    .foregroundColor(.blue)
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .padding(.top, 30)
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
                acceptBoxIsCheck = false
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
