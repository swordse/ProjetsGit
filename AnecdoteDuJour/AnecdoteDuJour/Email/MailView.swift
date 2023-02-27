//
//  MailView.swift
//  AnecdoteDuJour
//
//  Created by Raphaël Goupille on 25/01/2023.
//

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    
    var to: String
    var subject: String
    var message: String

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        if MFMailComposeViewController.canSendMail() {
            let view = MFMailComposeViewController()
            view.setToRecipients([to])
            view.setSubject(subject)
            view.setMessageBody(message, isHTML: false)
            view.mailComposeDelegate = context.coordinator
            return view
        } else {
            return MFMailComposeViewController()
        }
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    typealias UIViewControllerType = MFMailComposeViewController
    
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


