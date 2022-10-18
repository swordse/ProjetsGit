//
//  SubmitForm.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 22/06/2022.
//

import SwiftUI

enum ImageSubmitForm: String {
    case category = "square.grid.2x2"
    case source = "book.closed"
    case text = "pencil"
    case author = "figure.stand"
    case word = "bubble.right"
}


struct SubmitForm: View {
    
    var image: ImageSubmitForm
    var categoryName: String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: image.rawValue)
                    .font(.system(size: 18))
                Text(categoryName).frame(alignment: .leading)
                    .font(.system(size: 18, weight: .medium))
            }
            
            Rectangle()
                .frame(height: 0.5)
                .background(Color.white)
                .opacity(0.5)
        }
        
    }
}

struct SubmitForm_Previews: PreviewProvider {
    static var previews: some View {
        SubmitForm(image: ImageSubmitForm.category, categoryName: "Categorie")
    }
}
