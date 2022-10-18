//
//  MenuRectangleView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 31/05/2022.
//

import SwiftUI

struct MenuRectangleView: View {
    
    var geometry: GeometryProxy
    var section: Menu
    
    var body: some View {
            VStack(spacing: 20) {
                section.icon
                    .resizable()
                    .foregroundColor(.white)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width/7)
                    .padding(.top, geometry.size.width/14)
                
                Text(section.title)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.bottom, geometry.size.height/20)
            }.frame(width: geometry.size.width/2.2, height: geometry.size.width/2.5)
            .background(section.color)
            .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}

struct MenuRectangleView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
            MenuRectangleView(geometry: proxy, section: Menu.menuCategories[0])
        }
    }
}
