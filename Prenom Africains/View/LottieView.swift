//
//  LottieView.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 22/03/2021.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var name: String
    var loopMode: LottieLoopMode = .playOnce
    var fromMarker: String?
    var toMarker: String?

    var animationView = LottieAnimationView()

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        animationView.animation = LottieAnimation.named(name)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
		animationView.backgroundBehavior = .pause

        if let fromMarker = fromMarker {
            if let toMarker = toMarker {
                animationView.play(fromMarker: fromMarker, toMarker: toMarker, loopMode: loopMode) { _ in

                }
            }
        } else {
            animationView.play()
        }

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
		animationView.backgroundBehavior = .pause
	}
}
