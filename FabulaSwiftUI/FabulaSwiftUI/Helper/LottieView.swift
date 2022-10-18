//
//  Lottie.swift
//  FabulaSwiftUI
//
//  Created by Raphaël Goupille on 16/09/2022.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {

    let name: String
//    var loopMode: LottieLoopMode = .repeat(1)
    var numberOfRepeat: Float
    var height: CGFloat
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> some UIView {
        let view = UIView(frame: .zero)
        
        let animationView = AnimationView()
        let animation = Animation.named(name)
        animationView.animation = animation
        animationView.loopMode = .repeat(numberOfRepeat)
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([animationView.heightAnchor.constraint(equalToConstant: height), animationView.widthAnchor.constraint(equalTo: view.widthAnchor)])
        return view
        }
        
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
        
    }

