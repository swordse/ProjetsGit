//
//  MailView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 16/10/2022.
//

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = MFMailComposeViewController
    
    var content: String
    var to: String
    var subject: String
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        if MFMailComposeViewController.canSendMail() {
            let view = MFMailComposeViewController()
            view.mailComposeDelegate = context.coordinator
            view.setToRecipients([to])
            view.setSubject(subject)
            view.setMessageBody(content, isHTML: false)
            return view
        } else {
            return MFMailComposeViewController()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {

    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView
        
        init(_ parent: MailView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    }
    
}

