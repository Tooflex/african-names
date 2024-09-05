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

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = LottieAnimationView()
        animationView.animation = LottieAnimation.named(name)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.backgroundBehavior = .pause

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)

        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])

        context.coordinator.animationView = animationView

        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView>) {
        context.coordinator.updateAnimation(fromMarker: fromMarker, toMarker: toMarker, loopMode: loopMode)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: LottieView
        var animationView: LottieAnimationView?

        init(_ parent: LottieView) {
            self.parent = parent
        }

        func updateAnimation(fromMarker: String?, toMarker: String?, loopMode: LottieLoopMode) {
            guard let animationView = animationView else { return }

            animationView.stop()
            if let fromMarker = fromMarker, let toMarker = toMarker {
                animationView.play(fromMarker: fromMarker, toMarker: toMarker, loopMode: loopMode)
            } else {
                animationView.play()
            }
        }
    }
}
