//
//  MarqueeTextView.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 20/11/2022.
//

import SwiftUI

// MARK: Marquee Text View
struct MarqueeTextView: View {
	@State var text: String
	var font: UIFont

	@State var storedSize: CGSize = .zero
	@State var offset: CGFloat = 0

	var animationSpeed: Double = 0.02
	var delayTime: Double = 0.5
	var padding: Double = 0

	@Environment(\.colorScheme) var scheme

	var body: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			Text(text)
				.font(Font(font))
				.offset(x: offset)
				.padding(.horizontal, padding)
		}
		// Disabling manual scrolling
		.disabled(true)
		.onAppear {
			let baseText = text

			(1...5).forEach { _ in
				text.append(" ")
			}
			storedSize = textSize()
			text.append(baseText)

			let timing: Double = (animationSpeed * storedSize.width)

			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				withAnimation(.linear(duration: timing)) {
					offset = -storedSize.width
				}
			}
		}.onReceive(Timer.publish(every: ((animationSpeed * storedSize.width) + delayTime), on: .main, in: .default).autoconnect()) { _ in
			offset = 0
			withAnimation(.linear(duration: (animationSpeed * storedSize.width))) {
				offset = -storedSize.width
			}
		}
	}

	func textSize() -> CGSize {
		let attributes = [NSAttributedString.Key.font: font]
		let size = (text as NSString).size(withAttributes: attributes)
		return size
	}
}
