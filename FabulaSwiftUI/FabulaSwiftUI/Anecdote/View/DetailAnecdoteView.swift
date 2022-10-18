//
//  DetailAnecdoteView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 02/06/2022.
//

import SwiftUI
import Firebase

struct DetailAnecdoteView: View {
    
    @Binding var anecdote: Anecdote
    @StateObject var viewModel = DetailAnecdoteViewModel()
    
    @State private var selectedComment = Comment(commentId: "", anecdoteId: "", commentText: "", date: nil, userName: "", userId: "", userImage: nil)
    @State private var isConnexionSheetPresented = false
    @State private var isShareSheetPresented = false
    @State private var newComment = ""
    @State private var showChangeCommentView = false
    @State private var showCommentSubmitAlert = false
    
    @AppStorage(Keys.currentUserSaved) var user: Data = Data()
    
    var body: some View {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                if viewModel.showProgressView {
                    CustomProgressView()
                }
                List {
                    // Anecdote Section
                    Section {
                        AnecdoteView(isLineLimit: false, isDetail: true, anecdote: anecdote)
                            .hideRowSeparator()
                    }
                    .listRowBackground(Color.background)
                    // Share Button Section
                    Section {
                        Button {
                            isShareSheetPresented.toggle()
                        } label: {
                            ButtonView(text: "PARTAGER", isShare: true)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.vertical)
                    .listRowBackground(Color.background)
                    .sheet(isPresented: $isShareSheetPresented) {
                        ShareSheetView(activityItems: ["Voici une anecdote que j'ai trouvé sur l'application Fabula: \n\(anecdote.text)"])
                    }
                    // Source Section
                    Section {
                        if anecdote.source != nil {
                            SourceView(anecdote: anecdote, viewModel: viewModel)
                        }
                    }
                    .padding(.vertical)
                    .listRowBackground(Color.background)
                    // Comment Section
                    Section {
                        LazyVStack(alignment: .leading){
                            HStack {
                                Image(systemName: "pencil")
                                    .font(.headline)
                                Text("Ajouter un commentaire")
                                    .font(.headline)
                            }
                            TextEditor(text: $newComment)
                                .textEditorBackGround()
                                .frame(height: 60)
                                .onTapGesture {
                                    if user.isEmpty {
                                        isConnexionSheetPresented = true
                                        hideKeyboard()
                                    }
                                }
                            Button {
                                guard !newComment.isEmpty else { return }
                                showCommentSubmitAlert.toggle()
                            } label: {
                                ButtonView(text: "SOUMETTRE")
                            }
                            .padding(.vertical)
                            .buttonStyle(.plain)
                            .disabled(user.isEmpty)
                            
                            Spacer()
                            
                            ForEach($viewModel.comments, id: \.commentText) { $comment in
                                if viewModel.currentUser?.userId == comment.userId {
                                    CommentView(showCommentChangeButton: true, comment: comment)
                                        .rowSeparatorColor(color: .black)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .onTapGesture {
                                            selectedComment = comment
                                            showChangeCommentView.toggle()
                                        }
                                } else {
                                    CommentView(comment: comment)
                                        .rowSeparatorColor(color: .black)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }.padding(.top, 5)
                            .padding(.bottom, 5)
                            .listRowBackground(Color.background)
                    }
                }
                .hideScrollBackground()
                .listStyle(.plain)
                .onTapGesture {
                    hideKeyboard()
                }
                .onAppear {
                    Task {
                        if viewModel.comments.isEmpty {
                            guard let anecdoteId = anecdote.id else { return }
                            viewModel.getComment(anecdoteId: anecdoteId)
                        }
                    }
                }
                .onAppear {
                    viewModel.updateUserConnexionState()
                }
            }
            .sheet(isPresented: $showChangeCommentView, onDismiss: {
                viewModel.updateCommentAfterChange(comment: selectedComment)
            }, content: {
                ChangeCommentView(comment: $selectedComment)
            })
            .sheet(isPresented: $isConnexionSheetPresented, onDismiss: { viewModel.updateUserConnexionState() }, content: {
                AccountView()
            })
            .alert(isPresented: $viewModel.commentError, content: {
                Alert(title: Text("Erreur"), message: Text("Une erreur est survenue lors du chargement des commenaires."), dismissButton: .default(Text("OK")))
            })
            .alert(isPresented: $showCommentSubmitAlert, content: {
                Alert(title: Text("Votre commentaire est prêt."), message: Text("En le soumettant vous acceptez les règles d'utilisation de l'application."), primaryButton: .default(Text("ACCEPTER"), action: {
                    viewModel.save(commentToSave: newComment, anecdoteId: anecdote.id ?? "")
                    newComment = ""
                }), secondaryButton: .cancel()
                )
            })
            .navigationTitle("Detail")
//        }
    }
}

struct DetailAnecdoteView_Previews: PreviewProvider {
    static var previews: some View {
        DetailAnecdoteView(anecdote: .constant(Anecdote(category: .arts, title: "L'histoire est amusante", text: "Il faut que j'écrive du texte pour remplir le placeholder dans le seul but de voir le résultat final. Il ne s'agit ici bien évidemment pas d'une anecdote à part entière.", source: "https://www.hackingwithswift.com/100/swiftui/100",date: Timestamp(seconds: 1643151600, nanoseconds: 0), isFavorite: false)))
    }
}
