//
//  SwiftUIView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 21/07/2022.
//

import SwiftUI

struct AccountManagerView: View {
    
    @StateObject var viewModel = AccountManagerViewModel()
    
    @State private var showImagePicker = false
    @State private var image: UIImage?
    
    @AppStorage(Keys.currentUserSaved) var user: Data = Data()
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            if user.isEmpty {
                AccountView(isAccountManager: true)
            } else {
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Changez votre photo de profil")
                            .font(.title3)
                        Rectangle().frame(height: 0.5)
                    }
                    VStack(spacing: 20){
                        HStack(spacing: 30) {
                            if viewModel.photo != nil {
                                Image(uiImage: (viewModel.photo!))
                                    .resizable()
                                    .cornerRadius(40)
                                    .frame(width: 80, height: 80)
                                    .background(Color.black.opacity(0.2))
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person")
                                    .resizable()
                                    .padding()
                                    .cornerRadius(40)
                                    .frame(width: 80, height: 80)
                                    .background(Color.black.opacity(0.2))
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                            }
                            Button {
                                showImagePicker.toggle()
                            } label: {
                                Text("Changez votre photo")
                            }
                        }
                        Button {
                            viewModel.changeUserPhoto()
                        } label: {
                            ButtonView(text: "SOUMETTRE")
                        }
                        .frame(height: 40)
                        .buttonStyle(.plain)
                    }
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Changez votre nom d'utilisateur")
                            .font(.title3)
                        Rectangle().frame(height: 0.5)
                        TextField("Nouveau nom utilisateur", text: $viewModel.userName)
                            .padding(.vertical)
                        Button {
                            viewModel.changeUserName()
                        } label: {
                            ButtonView(text: "SOUMETTRE")
                        }
                        .frame(height: 40)
                        .buttonStyle(.plain)
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(image: $image)
                    }
                    .onChange(of: image) { newValue in
                        guard let image = image else {
                            return
                        }
                        viewModel.photo = image
                    }
                }
                .padding(.horizontal)
            }
            if viewModel.isShowingProgress {
                CustomProgressView()
            }
        }
        .onTapGesture {
            hideKeyboard()
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text(viewModel.alertMessage.title), message: Text(viewModel.alertMessage.message), dismissButton: .default(Text("OK")))
        }
        .onAppear(perform: { viewModel.getCurrentUserInfo() })
    }
    
}

struct AccountManagerView_Previews: PreviewProvider {
    static var previews: some View {
        AccountManagerView()
    }
}
