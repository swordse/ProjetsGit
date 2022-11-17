//
//  ChangeCommentView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 21/07/2022.
//

import SwiftUI

struct ChangeCommentView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel = ChangeCommentViewModel()
    
    @State private var acceptBoxIsCheck = false
    @State private var showRulesAlert = false
    
    @Binding var comment: Comment
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                VStack {
                    Text("Vous pouvez modifier votre commentaire.")
                    TextEditor(text: $comment.commentText)
                        .frame(height: 100)
                        .textEditorBackGround()
                        .cornerRadius(10)
                        .padding()
                    HStack {
                        Button {
                            acceptBoxIsCheck.toggle()
                        } label: {
                            Image(systemName: acceptBoxIsCheck ? "checkmark.square" : "square")
                                .foregroundColor(.white)
                        }
                        .buttonStyle(PlainButtonStyle())
                        Button {
                            let stringUrl = "https://www.sites.google.com/view/appfabula/accueil/règles-soumission-des-commentaires?pli=1"
                            let encoded = stringUrl.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
                            let url = URL(string: encoded!)
                            UIApplication.shared.open(url!)
                        } label: {
                            Text("J'accepte les règles de soumission")
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .alert(isPresented: $showRulesAlert) {
                            Alert(title: Text("Vos changements sont prêts."), message: Text("Si votre commentaire ne respecte pas les règles de soumission, il sera supprimé. Dans une telle situation, votre compte pourra également être supprimé."), primaryButton: .default(Text("J'AI COMPRIS"), action: {
                                viewModel.updateComment(comment: comment)
                                acceptBoxIsCheck = false
                            }), secondaryButton: .cancel())
                        }
                    }.padding(.horizontal)
                    Button {
                        showRulesAlert = true
                    } label: {
                        ZStack {
                            Color( .systemBlue)
                                .cornerRadius(10)
                            Text("SOUMETTRE")
                                .padding(10)
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        .padding(.horizontal)
                        .frame(height: 40)
                    }
                    .buttonStyle(.plain)
                    .disabled(!acceptBoxIsCheck)
                    .alert(isPresented: $viewModel.showAlert) {
                        Alert(title: Text(viewModel.alertMessage.title), message: Text((viewModel.alertMessage.message)), dismissButton: .default(Text("OK"), action: {
                            presentationMode.wrappedValue.dismiss()
                        }))
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "x.circle.fill")
                                .foregroundColor(.white)
                                .font(.caption)
                        }
                    }
                }
                if viewModel.showProgressView {
                    CustomProgressView()
                }
            }
        }.tintOrAccentColor(color: .white)
            .onChange(of: viewModel.showAlert) { newValue in
                print(viewModel.showAlert)
            }
    }
}

struct ChangeCommentView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeCommentView(comment: .constant(Comment(commentId: "", anecdoteId: "", commentText: "", date: nil, userName: "", userId: "", userImage: nil)))
    }
}
