//
//  ButtonView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 30/07/2022.
//

import SwiftUI

struct ButtonView: View {
    var text: String
    var color = Color.blue
    var isShare = false
    
    var body: some View {
        HStack(alignment: .center) {
            Text(text)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
            if isShare {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.white)
                    .padding(.trailing)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10, style: .circular)
                .fill(color)
                .frame(height: 40)
        )
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(text: "PARTAGER")
    }
}
