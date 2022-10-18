//
//  UserNavBar.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 20/09/2022.
//

import SwiftUI

struct UserNavBar: View {
    
    @Binding var userAccountIsPresented: Bool
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Button {
                    userAccountIsPresented = true
                } label: {
                    Image(systemName: "person")
                        .foregroundColor(.white)
                        .font(.title2)
                        .frame(width: 40)
                        .padding(10)
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
}

struct UserNavBar_Previews: PreviewProvider {
    static var previews: some View {
        UserNavBar(userAccountIsPresented: .constant(false))
    }
}
