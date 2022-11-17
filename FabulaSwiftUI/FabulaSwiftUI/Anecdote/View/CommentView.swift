//
//  CommentView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 02/06/2022.
//

import SwiftUI
import Firebase

struct CommentView: View {
    
    var comment: Comment
    var fabulaUserId: String?
    
    @Binding var showChangeCommentView: Bool
    @Binding var selectedComment: Comment
    
    @StateObject var viewModel = CommentViewModel()
    @State private var showAlert = false
    @State private var showBlockUserAlert = false
    @State private var resultMessage: (title: String, message: String)?
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    
                    viewModel.image?
                        .resizable()
                        .cornerRadius(15)
                        .frame(width: 30, height: 30)
                        .background(Color.black.opacity(0.2))
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                    
                    Text(comment.userName)
                        .foregroundColor(.primary)
                        .padding(.bottom, 5)
                        .padding(.top, 10)
                    Spacer()
                    Text(comment.date != nil ? transformDateToString(timestamp: comment.date!) : "")
                        .font(.caption)
                        .foregroundColor(.primary)
                }
                Text(comment.commentText)
                    .foregroundColor(.primary)
                    .fontWeight(.light)
                    .multilineTextAlignment(.leading)
                
                HStack(alignment: .center) {
                    if comment.userId != fabulaUserId {
                        Button {
                            showAlert = true
                        } label: {
                            Image(systemName: "exclamationmark.circle")
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.vertical)
                        .alert(isPresented: $showAlert, content: {
                            if viewModel.alertMessage.title == "" {
                                return Alert(title: Text("COMMENTAIRE ABUSIF\nVous voulez signaler ce commentaire comme étant abusif ?"), message: Text("Nous l'examinerons sous 24h et le supprimerons au besoin."), primaryButton: .default(Text("SIGNALER"), action: {
                                    viewModel.reportComment(comment: comment)
                                }), secondaryButton: .cancel())
                            } else {
                                return Alert(title: Text(viewModel.alertMessage.title), message: Text(viewModel.alertMessage.message), dismissButton: .default(Text("OK")))
                            }
                        })
                        Button {
                            showBlockUserAlert = true
                        } label: {
                            Image(systemName: "person.crop.circle.badge.xmark")
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                        .buttonStyle(PlainButtonStyle())
                        .alert(isPresented: $showBlockUserAlert) {
                            Alert(title: Text("MASQUER CET UTILISATEUR"), message: Text("Si vous acceptez, tous les commentaires de cet utilisateur seront masqués."), primaryButton: .default(Text("ACCEPTER"), action: {
                                UserDefaultsManager.manager.saveAbuseCommentUser(userId: comment.userId)
                            }), secondaryButton: .cancel())
                        }
                    }
                    Spacer()
                    if comment.userId == fabulaUserId {
                        Button {
                            print("showChangeCommentView value = \(showChangeCommentView)")
                            self.showChangeCommentView = true
                            self.selectedComment = comment
                        } label: {
                            HStack(alignment: .center) {
                                Spacer()
                                Image(systemName: "square.and.pencil")
                                    .foregroundColor(.primary)
                                Text("Modifier")
                                    .font(.caption2)
                                    .foregroundColor(.primary)
                                    .padding(.top, 5)
                            }
                        }.buttonStyle(.plain)
                    }
                }
                Rectangle().frame(height: 0.5)
                    .background(Color.primary)
            }
            if viewModel.showProgressView {
                CustomProgressView()
            }
        }
        .onAppear {
            guard let url = comment.userImage else { return }
            viewModel.downsample(imageAt: url, to: CGSize(width: 40, height: 40))
        }
        .onChange(of: viewModel.showResultAlert) { newValue in
            showAlert = true
        }
    }
    
    func transformDateToString(timestamp: Timestamp) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        let date = timestamp.dateValue()
        return formatter.string(from: date)
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        
        CommentView(comment: Comment(commentId: "", anecdoteId: "ssss", commentText: "ceci est un commentaire pas très gentil, fait par une utilisateur un peu limité.", date: Timestamp(seconds: 1643151600, nanoseconds: 0), userName: "Bob", userId: "dedede"), fabulaUserId: "dedede", showChangeCommentView: .constant(false), selectedComment: .constant(Comment(commentId: "", anecdoteId: "ssss", commentText: "ceci est un commentaire pas très gentil, fait par une utilisateur un peu limité.", date: Timestamp(seconds: 1643151600, nanoseconds: 0), userName: "Bob", userId: "dedede")))
    }
}
