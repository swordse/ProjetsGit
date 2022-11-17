//
//  CommentViewModel.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 19/07/2022.
//

import Foundation
import SwiftUI

struct CacheImage: @unchecked Sendable {
    static var cache = NSCache<NSString, UIImage>()
}

extension CommentView {
    
    final class CommentViewModel: ObservableObject {
        
        @Published var image: Image?
        @Published var showProgressView = false
        @Published var showResultAlert = false
        @Published var alertMessage = (title: "", message: "")
        
        let commentSession = CommentService()
        let cache = CacheImage.cache
        
        func downsample(imageAt imageURL: URL,
                        to pointSize: CGSize,
                        scale: CGFloat = UIScreen.main.scale) {
            
            
            if let cachedUIImage =
                cache.object(forKey: NSString(string: imageURL.absoluteString)) { 
                let cacheImage = Image(uiImage: cachedUIImage)
                self.image = cacheImage
            } else {
                Task {
                    let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
                    guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions) else {
                        return
                    }
                    
                    let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
                    
                    let downsampleOptions: [CFString: Any] = [
                        kCGImageSourceCreateThumbnailFromImageAlways: true,
                        kCGImageSourceShouldCacheImmediately: true,
                        kCGImageSourceCreateThumbnailWithTransform: true,
                        kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
                    ]
                    
                    guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions as CFDictionary) else {
                        return
                    }
                    
                    // Return the downsampled image as UIImage
                    let UIImage = UIImage(cgImage: downsampledImage)
                    self.cache.setObject(UIImage, forKey: NSString(string: imageURL.absoluteString))
                    
                    let downImage = Image(uiImage: UIImage)
                    DispatchQueue.main.async {
                        self.image = downImage
                    }
                }
            }
        }
        
        func reportComment(comment: Comment) {
            showProgressView = true
            
            let commentToSave: [String: Any] = [
                "reportCommentId": comment.commentId,
                "reportCommentText": comment.commentText,
                "commentUserId": comment.userId,
                "commentUserName": comment.userName,
                "anecdoteId": comment.anecdoteId]
            
            commentSession.commentReport(comment: commentToSave) {  result in
                switch result {
                case.success:
                    self.showProgressView = false
                    self.showResultAlert = true
                    self.alertMessage = (title: "Merci", message: "Nous étudierons ce signalement sous 24 heures.")
                case.failure(_):
                    self.showResultAlert.toggle()
                    self.alertMessage = (title: "Erreur", message: "Une erreur s'est produite. Veuillez réessayer ultérieurement et vérifiez votre connexion internet.")
                    self.showProgressView = false
                }
            }
        }
    }
}

