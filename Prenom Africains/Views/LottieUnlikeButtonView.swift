//
//  LottieUnlikeButtonView.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 26/04/2021.
//

import SwiftUI
import Lottie

struct LottieUnlikeButtonView: UIViewRepresentable {
    
    typealias UIViewType = UIView
    let animationView = AnimatedButton()
    let filename: String
    let action: () -> Void
    
    func makeUIView(context: UIViewRepresentableContext<LottieUnlikeButtonView>) -> UIView {
        let view = UIView()
        
        
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieUnlikeButtonView>) {
        uiView.subviews.forEach({ $0.removeFromSuperview() })

        
        let animation = Animation.named(filename)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.clipsToBounds = false
        
        /// Set animation play ranges for touch states
        animationView.setPlayRange(fromMarker: "touchDownStart1", toMarker: "touchDownEnd1", event: .touchUpInside)
        animationView.setPlayRange(fromMarker: "touchDownEnd1", toMarker: "touchUpCancel1", event: .touchUpOutside)
        animationView.setPlayRange(fromMarker: "touchDownEnd1", toMarker: "touchUpEnd1", event: .touchUpInside)
        
        uiView.addSubview(animationView)
        
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: uiView.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: uiView.heightAnchor),
        ])
        
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    class Coordinator: NSObject {
        let parent: LottieUnlikeButtonView
        
        init(_ parent: LottieUnlikeButtonView) {
            self.parent = parent
            super.init()
            parent.animationView.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        }
        
        // this function can be called anything, but it is best to make the names clear
        @objc func touchUpInside() {
            parent.action()
        }
    }
}

struct LottieUnlikeButtonView_Previews: PreviewProvider {
    static var previews: some View {
        LottieUnlikeButtonView(filename: "heart_like") {

        }
    }
}
