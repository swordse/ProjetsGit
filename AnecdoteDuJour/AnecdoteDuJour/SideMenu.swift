////
////  SideMenu.swift
////  AnecdoteDuJour
////
////  Created by Raphaël Goupille on 18/01/2023.
////
//
//import SwiftUI
//
//struct SideMenu: View {
//    
//    let menus = ["Réglage", "Favoris", "Légale"]
//    
//    var body: some View {
//        
//            VStack {
//                Text("Menu")
//                    .foregroundColor(.black)
//                    .padding(40)
//                
//                ForEach(menus, id: \.self) { menu in
//                    NavigationLink {
//                        TestView()
//                    } label: {
//                        Text(menu)
//                    }
//
//                }
//                Spacer()
//            }
//            .edgesIgnoringSafeArea(.bottom)
//            .frame(width: 150)
//        .background(Color(.systemGray6))
//
//    }
//}
//
//struct SideMenu_Previews: PreviewProvider {
//    static var previews: some View {
//        SideMenu()
//    }
//}
