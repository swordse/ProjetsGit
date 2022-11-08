//
//  CustomProgressView.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 08/10/2022.
//

import SwiftUI

struct CustomProgressView: View {
    var body: some View {
        ProgressView()
        .progressViewStyle(.circular)
        .scaleEffect(2)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color.clear)
        .padding(.top, 50)
    }
}

struct CustomProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CustomProgressView()
    }
}
