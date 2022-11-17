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
    
    @State private var selectedComment = Comment(commentId: "", anecdoteId: "ssss", commentText: "", date: Timestamp(seconds: 1643151600, nanoseconds: 0), userName: "", userId: "")
    @State private var isConnexionSheetPresented = false
    @State private var isShareSheetPresented = false
    @State private var newComment = ""
    @State private var showChangeCommentView = false
    @State private var showCommentSubmitAlert = false
    @State private var acceptBoxIsCheck = false
    
    @AppStorage(Keys.currentUserSaved) var user: Data = Data()
    
    @State private var fabulaUser: FabulaUser?
    
    @AppStorage(Keys.saveAbuseCommentUserId, store: .standard) var saveAbuseCommentUserId: Data = Data()
    
    @State private var abuseUsers: [String]?
    
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
                    VStack {
                        Button {
                            isShareSheetPresented.toggle()
                        } label: {
                            ButtonView(text: "PARTAGER", isShare: true)
                        }
                        .buttonStyle(.plain)
                        .sheet(isPresented: $isShareSheetPresented) {
                            if let url = URL(string: "https://apps.apple.com/us/app/fabula/id6443920494") {
                                ShareSheetView(activityItems: ["Voici une anecdote que j'ai trouvé sur l'application Fabula: \n\(anecdote.text)", url])
                            }
                        }
                    }
                    .hideRowSeparator()
                }
                .listRowBackground(Color.background)
                // Source Section
                Section {
                    if anecdote.source != nil {
                        SourceView(anecdote: anecdote, viewModel: viewModel)
                            .hideRowSeparator()
                    }
                }
                .listRowBackground(Color.background)
                // Comment Section
                Section {
                    VStack(alignment: .leading){
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
                                if fabulaUser == nil {
                                    isConnexionSheetPresented = true
                                    hideKeyboard()
                                }
                            }
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
                        }
        
                        Button {
                            guard !newComment.isEmpty else { return }
                            showCommentSubmitAlert.toggle()
                        } label: {
                            ButtonView(text: "SOUMETTRE")
                        }
                        .padding(.vertical)
                        .buttonStyle(.plain)
                        .disabled(fabulaUser == nil || newComment.isEmpty || !acceptBoxIsCheck)
                        
                        Spacer()
                        
                        ForEach($viewModel.comments, id: \.commentId) { $comment in
                                    if abuseUsers == nil {
                                        CommentView(comment: comment, fabulaUserId: fabulaUser?.userId, showChangeCommentView: $showChangeCommentView, selectedComment: $selectedComment)
                                    } else if abuseUsers!.contains(comment.userId) == false {
                                        CommentView(comment: comment, fabulaUserId: fabulaUser?.userId, showChangeCommentView: $showChangeCommentView, selectedComment: $selectedComment)
                                    }
                                }
                        .sheet(isPresented: $showChangeCommentView, onDismiss: {
                                        viewModel.updateCommentAfterChange(comment: selectedComment)
                                    }, content: {
                                            ChangeCommentView(comment: $selectedComment)
                                    })
                        }
                    }
                    .listRowBackground(Color.background)
                    .hideRowSeparator()
                }
            }
            .hideScrollBackground()
            .listStyle(.grouped)
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
                decodeUser(userData: user)
                decodeSaveAbuseCommentUserId(userData: saveAbuseCommentUserId)
            }
        .onChange(of: saveAbuseCommentUserId, perform: { newValue in
            decodeSaveAbuseCommentUserId(userData: newValue)
        })
            .onChange(of: user, perform: { _ in
                    decodeUser(userData: user)
                })
            .sheet(isPresented: $isConnexionSheetPresented, content: {
                AccountView()
            })
            .alert(isPresented: $viewModel.commentError, content: {
                Alert(title: Text("Erreur"), message: Text("Une erreur est survenue lors du chargement des commentaires."), dismissButton: .default(Text("OK")))
            })
            .alert(isPresented: $showCommentSubmitAlert, content: {
                Alert(title: Text("Votre commentaire est prêt."), message: Text("Si votre commentaire ne respecte pas les règles de soumission, il sera supprimé. Dans une telle situation, votre compte pourra également être supprimé."), primaryButton: .default(Text("J'AI COMPRIS"), action: {
                    viewModel.save(commentToSave: newComment, anecdoteId: anecdote.id ?? "", user: fabulaUser)
                    newComment = ""
                    acceptBoxIsCheck = false
                }), secondaryButton: .cancel()
                )
            })
            .navigationTitle("Detail")
            .navigationBarTitleDisplayMode(.large)
    }
    
    func decodeUser(userData: Data) {
        if let decoded = try? JSONDecoder().decode(FabulaUser.self, from: userData) {
            fabulaUser = decoded
        } else {
            fabulaUser = nil
        }
    }
    
    func decodeSaveAbuseCommentUserId(userData: Data) {
        if let decoded = try? JSONDecoder().decode([String].self, from: userData) {
            print("ABUSE USER est décodé")
            abuseUsers = decoded
            print("CONTENU D'ABUSE USE: \(decoded)")
        } else {
            abuseUsers = nil
            print("ABUSE USER est NILLLL")
        }
    }
}

struct DetailAnecdoteView_Previews: PreviewProvider {
    static var previews: some View {
        DetailAnecdoteView(anecdote: .constant(Anecdote(category: .arts, title: "L'histoire est amusante", text: "Il faut que j'écrive du texte pour remplir le placeholder dans le seul but de voir le résultat final. Il ne s'agit ici bien évidemment pas d'une anecdote à part entière.", source: "https://www.hackingwithswift.com/100/swiftui/100",date: Timestamp(seconds: 1643151600, nanoseconds: 0), isFavorite: false)))
    }
}
