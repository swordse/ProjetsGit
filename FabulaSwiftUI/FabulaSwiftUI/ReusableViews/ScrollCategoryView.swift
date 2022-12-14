//
//  ScrollCategoryQuoteView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 13/06/2022.
//

import SwiftUI

struct ScrollCategoryView<T: Hashable & RawRepresentable & CaseIterable>: View where T.RawValue == String {
    
    @Binding var selectedCategory: T
    var categoryColor: Color
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(Array(T.allCases), id: \.self ) { categorie in
                        Button {
                            selectedCategory = categorie
                        } label: {
                            Text(categorie.rawValue)
                                .font(categorie.rawValue == "Divertissement" ? .system(size: 13) : .system(size: 17))
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .frame(width: 100, height: 50)
                                    .background(categoryColor)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .overlay(RoundedRectangle(cornerRadius: 15)
                                        .stroke(selectedCategory == categorie ? .white : categoryColor, lineWidth: 1))
                    }
                    .padding(.vertical, 1)
                    .padding(.leading, 5)
                }
            }
        }.frame(height: 51)
            .background(Color.background.opacity(0.9))
    }
}

struct ScrollCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollCategoryView(selectedCategory: .constant(QuoteCategoriesMenu.nouveautes), categoryColor: Color.blue)
    }
}
