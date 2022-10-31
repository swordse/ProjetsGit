//
//  NewAccountView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 22/06/2022.
//

import SwiftUI

struct AccountView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel = AccountViewModel()
    
    let authentification = Authentification()
    
    @State private var credentials: Credentials?
    @State var isDeleteAccount = false
    @State var isAccountManager = false
    @State private var showPasswordReset = false
    @State private var image: UIImage?
    @State private var showImagePicker = false
    @State private var showAccountManagerView = false
    
    @State private var faceIdError: Authentification.AuthentificationError?
    
    @AppStorage(Keys.currentUserSaved) var user: Data = Data()
    
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.background
                    .ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    ZStack(alignment: .center) {
                        Color.background
                            .ignoresSafeArea()
                        if user.isEmpty {
                            LazyVStack(spacing: 30) {
                                Spacer()
                                Spacer()
//                                if viewModel.isConnexion {
//                                    LottieView(name: "login-and-sign-up", numberOfRepeat: 1, height: 200)
//                                        .frame(height: 200)
//                                }
                                if !viewModel.isConnexion {
                                    HStack {
                                        if viewModel.userImage != nil {
                                            Image(uiImage: (viewModel.userImage!))
                                                .resizable()
                                                .cornerRadius(40)
                                                .frame(width: 80, height: 80)
                                                .background(Color.black.opacity(0.2))
                                                .aspectRatio(contentMode: .fill)
                                                .clipShape(Circle())
                                        } else {
                                            Image(uiImage: UIImage(systemName: "person")!)
                                                .resizable()
                                                .padding()
                                                .cornerRadius(40)
                                                .frame(width: 80, height: 80)
                                                .background(Color.white.opacity(0.2))
                                                .aspectRatio(contentMode: .fill)
                                                .clipShape(Circle())
                                        }
                                        Button {
                                            showImagePicker.toggle()
                                        } label: {
                                            Text("Ajouter une image pour votre profil.")
                                        }
                                        .padding(.horizontal)
                                    }
                                    FormField(text: $viewModel.userName, isSecured: false, placeholderString: "  Nom d'utilisateur", imageToDisplay: DisplayImage.userName, textContentType: .name, keyboardType: .default)
                                }
                                FormField(text: $viewModel.email, isSecured: false, placeholderString: "  Email", imageToDisplay: DisplayImage.email, textContentType: .emailAddress, keyboardType: .emailAddress)
                                
                                FormField(text: $viewModel.password, isSecured: true, placeholderString: "  Mot de passe", imageToDisplay: DisplayImage.lock, textContentType: .password, keyboardType: .default)
                                
                                if !viewModel.isConnexion {
                                    Text("Au moins 6 caractères, 1 majuscule, un chiffre ou un caractère spécial")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                if viewModel.isConnexion {
                                    Button("Mot de passe oublié?") {
                                        showPasswordReset.toggle()
                                    }
                                }
                                
                                if !viewModel.isConnexion {
                                    FormField(text: $viewModel.confirmationPassword, isSecured: true, placeholderString: "  Confirmation mot de passe", imageToDisplay: DisplayImage.lock, textContentType: .password, keyboardType: .default)
                                }
                                LazyVStack(spacing: 30) {
                                    Button {
                                        viewModel.dispatcher()
                                    } label: {
                                        ButtonView(text: viewModel.isConnexion ? "CONNEXION": "CREER UN COMPTE")
                                    }
                                    .buttonStyle(.plain)
                                    .disabled(buttonDisabled())
                                    
                                    Button {
                                        withAnimation(.linear(duration: 0.5)) {
                                            viewModel.isConnexion.toggle()
                                        }                } label: {
                                            Text(viewModel.isConnexion ? "Pas de compte? Créez en un." : "Déjà un compte: Connectez-vous.")
                                                .bold()
                                        }
                                    if viewModel.isConnexion {
                                    if authentification.biometricType() != .none {
                                        Button {
                                            authentification.requestBiometricUnlock { (result: Result <Credentials, Authentification.AuthentificationError>) in
                                                switch result {
                                                case .success(let credentials):
                                                    viewModel.signIn(password: credentials.password, email: credentials.email)
                                                    // appeler la fonction de login avec ces credentials
                                                case .failure(let error):
                                                    print(error)
                                                    faceIdError = error
                                                    // appeler une alert avec l'erreur
                                                }
                                            }
                                        } label: {
                                            Image(systemName: authentification.biometricType() == .face ? "faceid" : "touchid")
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                            
                                        }
                                    }
                                }
                                }
                            }
                            .frame(alignment: .center)
                        }
                        else {
                            if !isDeleteAccount  {
                                LazyVStack {
                                    Spacer()
                                        .frame(height: 50)
                                    Text("Vous êtes connecté")
                                        .font(.system(.title2, design: .rounded))
                                        .bold()
                                        .padding(.top, 20)
                                        .padding(.bottom, 60)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                                    Button {
                                        viewModel.logOut()
                                    } label: {
                                        ButtonView(text: "DECONNEXION")
                                    }
                                    
                                    Button {
                                        showAccountManagerView.toggle()
                                    } label: {
                                        Text("Modifier votre profil")
                                            .fontWeight(.medium)
                                            .foregroundColor(.blue)
                                    }.padding(.top, 40)
                                }
                                .frame(maxHeight: .infinity)
                            } else {
                                LazyVStack(spacing: 40) {
                                    Text("Supprimez votre compte")
                                        .foregroundColor(.red)
                                        .font(.title3)
                                        .bold()
                                        .padding(.top, 20)
                                    Text("Si vous supprimez votre compte, vous ne pourrez plus soumettre des propositions ou poster des commentaires.")
                                        .multilineTextAlignment(.center)
                                    Text("Pour supprimer votre compte vous devez à nouveau vous identifier.")
                                        .multilineTextAlignment(.center)
                                    FormField(text: $viewModel.email, isSecured: false, placeholderString: "Email", imageToDisplay: DisplayImage.email, textContentType: .emailAddress, keyboardType: .emailAddress)
                                    
                                    FormField(text: $viewModel.password, isSecured: true, placeholderString: "Mot de passe", imageToDisplay: DisplayImage.lock, textContentType: .password, keyboardType: .default)
                                    
                                    Button {
                                        viewModel.signInForDelete()
                                    } label: {
                                        ButtonView(text: "IDENTIFICATION")
                                    }
                                    .buttonStyle(.plain)
                                    
                                    if viewModel.signInForDeleteIsSuccess {
                                        Button {
                                            viewModel.deleteUser()
                                        } label: {
                                            ButtonView(text: "SUPPRIMER", color: .red)
                                        }
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .onAppear(perform: {
                        viewModel.checkCurrentUser()
                    })
                    .navigationBarHidden(isDeleteAccount || isAccountManager)
                    .onTapGesture {
                        hideKeyboard()
                    }
                        .toolbar {
                            ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                                if !isDeleteAccount || !isAccountManager {
//                                    if !isAccountManager {
                                    Button {
                                        presentationMode.wrappedValue.dismiss()
                                    } label: {
                                        Image(systemName: "x.circle.fill")
                                    }
                                }
                            }
                        }
                    .alert(isPresented: $viewModel.showAlert) {
                        Alert(title: Text(viewModel.alertMessage.title), message: Text(viewModel.alertMessage.message), dismissButton: .default(Text("OK")))
                    }
                    .alert(item: $faceIdError) { error in
                        if error == .credentialsNotSaved {
                            return Alert(title: Text("Identifiants non sauvés"), message: Text(error.localizedDescription), primaryButton: .default(Text("OK"), action: {
                                viewModel.storeCredentialsNext = true
                            }),
                                         secondaryButton: .cancel())
                        } else {
                            return Alert(title: Text(error.localizedDescription))
                        }
                    }
                    .sheet(isPresented: $showPasswordReset) {
                        PasswordResetView()
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(image: $image)
                    }
                    .sheet(isPresented: $showAccountManagerView, content: {
                        AccountManagerView(isFromAccountView: true)
                    })
                    .onChange(of: image) { _ in
                        guard let image = image else { return }
                        guard let compressImage = image.jpegData(compressionQuality: 0.1) else { return }
                        viewModel.userImage =  UIImage(data: compressImage)
                    }
                }
                .navigationTitle("Connexion")
                if viewModel.isShowingProgress {
                    CustomProgressView()
                }
            }
        }
        .tintOrAccentColor(color: .white)
        .navigationViewStyle(.stack)
    }
    
    func buttonDisabled() -> Bool {
        if viewModel.isConnexion {
            if viewModel.email.isEmpty || viewModel.password.isEmpty {
                return true
            } else { return false }
        } else {
            if viewModel.userName.isEmpty || viewModel.email.isEmpty || viewModel.password.isEmpty || viewModel.confirmationPassword.isEmpty  {
                return true
            } else { return false }
        }
    }
    
}

struct NewAccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
