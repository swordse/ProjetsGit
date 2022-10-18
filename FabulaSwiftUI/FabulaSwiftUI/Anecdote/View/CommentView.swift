//
//  CommentView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 02/06/2022.
//

import SwiftUI
import Firebase

struct CommentView: View {
    
    var showCommentChangeButton = false
    var comment: Comment
    
    @StateObject var viewModel = CommentViewModel()
    
    var body: some View {
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
            if showCommentChangeButton {
                HStack(alignment: .center) {
                    Spacer()
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.primary)
                        Text("Modifier")
                            .font(.caption2)
                            .foregroundColor(.primary)
                .padding(.top, 5)
            }
            Rectangle().frame(height: 0.5)
                .background(Color.primary)
        }
        }
        .onAppear {
                guard let url = comment.userImage else { return }
                viewModel.downsample(imageAt: url, to: CGSize(width: 40, height: 40))
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
        CommentView(showCommentChangeButton: true, comment: Comment(commentId: "", anecdoteId: "ssss", commentText: "ceci est un commentaire pas très gentil, fait par une utilisateur un peu limité.", date: Timestamp(seconds: 1643151600, nanoseconds: 0), userName: "Bob", userId: "dedede"))
    }
}
