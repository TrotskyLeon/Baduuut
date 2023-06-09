//
//  LottieView.swift
//  Baduuut
//
//  Created by Jevon Levin on 21/03/23.
//

import SwiftUI
import Lottie
 
struct LottieView: UIViewRepresentable {
    let lottieFile: String
 
    
    let animationView = LottieAnimationView()
 
    func makeUIView(context: Context) -> some UIView {
        
        let view = UIView(frame: .zero)
 
        animationView.animation = LottieAnimation.named(lottieFile)
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        animationView.animationSpeed = lottieFile == "hello" ? 1 : 0.15
        animationView.loopMode = .loop
 
        view.addSubview(animationView)
 
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        animationView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

        return view
    }
 
    func updateUIView(_ uiView: UIViewType, context: Context) {
 
    }
}
