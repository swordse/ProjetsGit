//
//  ChangeCommentView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 21/07/2022.
//

import SwiftUI
import AVFoundation

struct ChangeCommentView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel = ChangeCommentViewModel()
    
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
                    Button {
                        viewModel.updateComment(comment: comment)
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
                        .buttonStyle(.plain)
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
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text(viewModel.alertMessage.title), message: Text((viewModel.alertMessage.message)), dismissButton: .default(Text("OK"), action: {
                    presentationMode.wrappedValue.dismiss()
                }))
            }
        }
    }
}

struct ChangeCommentView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeCommentView(comment: .constant(Comment(commentId: "", anecdoteId: "", commentText: "", date: nil, userName: "", userId: "", userImage: nil)))
    }
}
