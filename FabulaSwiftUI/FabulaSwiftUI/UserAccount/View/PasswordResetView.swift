//
//  PasswordResetView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 18/07/2022.
//

import SwiftUI

struct PasswordResetView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var email = ""
    
    @StateObject var viewModel = PasswordResetViewModel()
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                
                VStack {
                    Text("Complétez votre adresse email pour réinitialiser votre mot de passe.")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    FormField(text: $email, isSecured: false, placeholderString: "votre email", imageToDisplay: .email, textContentType: .emailAddress, keyboardType: .emailAddress)
                    
                    Button {
                        guard !email.isEmpty else { return }
                        viewModel.passwordReset(email: email)
                    } label: {
                        ButtonView(text: "REINITIALISER LE MOT DE PASSE")
                    }
                    .buttonStyle(.plain)
                    .disabled(email.isEmpty)
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Image(systemName: "x.circle.fill")
                                .foregroundColor(.white)
                        }
                    }
                }
                .alert(isPresented: $viewModel.showAlert, content: {
                    Alert(title: Text(viewModel.alertMessage.title), message: Text(viewModel.alertMessage.message), dismissButton: .default(Text("OK")))
                })
            }
        }
    }
}

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetView()
    }
}
