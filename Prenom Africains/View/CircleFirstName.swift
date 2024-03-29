//
//  CircleFirstName.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 22/03/2021.
//

import SwiftUI
import AVFoundation
import L10n_swift

let synthesizer = AVSpeechSynthesizer()

struct CircleFirstName: View {
    @Environment(\.colorScheme) var currentMode

    @Environment(\.verticalSizeClass) var vSizeClass

    @Environment(\.horizontalSizeClass) var hSizeClass

    var prenom: FirstnameDB
    var color: Color = .blue

    var body: some View {
        GeometryReader { geometry in
        VStack {
                ZStack {
                    if currentMode == .dark {
                        Circle()
                            .fill(color)
                            .frame(
                                width: geometry.size.width * 0.8 * sizeMultiplier(),
                                height: geometry.size.width * 0.8 * sizeMultiplier())
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.gray.opacity(0.7), radius: 10, x: -5, y: -5)
                    } else {
                        Circle()
                            .fill(color)
                            .frame(
                                width: geometry.size.width * 0.8 * sizeMultiplier(),
                                height: geometry.size.width * 0.8 * sizeMultiplier())
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    }

                    VStack {
                        Text(prenom.firstname)
                            .foregroundColor(.white)
                            .font(.system(size: 60 * CGFloat(sizeMultiplier())))
                            .minimumScaleFactor(0.2)
                            .lineLimit(1)
                            .frame(width: 250 * sizeMultiplier(), height: 140 * sizeMultiplier())
                            .offset(y: 40)
                            .shadow(color: Color.black.opacity(16.0), radius: 6, x: 5, y: 3)
                            .accessibility(label: Text("current firstname"))

                        Button(action: {
                            speakFirstname(firsnameStr: prenom.firstname)
                        }) {
                            LottieView(name: "sound", loopMode: .loop)
                                .frame(width: 54 * sizeMultiplier(), height: 54 * sizeMultiplier())
                        }.offset(y: 0)
                    }
                }
            }
        .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height, alignment: .center)
        .padding([.leading, .trailing], 10)
        }
    }

    func sizeMultiplier() -> CGFloat {

        // Check for a specific model
        if UIScreen.current == .iPhone5_8
            || UIScreen.current == .iPhone5_5
            || UIScreen.current == .iPhone6_1
            || UIScreen.current == .iPhone6_5 {
            return 1
        }

        // Check for multiple models
        if UIScreen.current == .iPhone4_7 {
            return 1
        }

        // Find all models larger than or equal to a certain screen size
        if UIScreen.current == .iPad10_5 {
            if UIDevice.current.orientation.isLandscape {
                return 0.5
            } else {
                return 0.8
            }
        }

        if UIScreen.current == .iPad10_9 {
            if UIDevice.current.orientation.isLandscape {
                return 0.5
            } else {
                return 0.8
            }
        }

        if UIScreen.current == .iPad12_9 {
            return 0.8
        }

        return 0.8
    }

    func speakFirstname(firsnameStr: String) {
        let utterance = AVSpeechUtterance(string: firsnameStr)

        switch prenom.gender {
        case Gender.male.rawValue:
				utterance.voice =
				AVSpeechSynthesisVoice.speechVoices().first(where: { $0.language.contains(L10n.shared.language) && $0.gender == AVSpeechSynthesisVoiceGender.male })

			case Gender.female.rawValue:
				utterance.voice =
				AVSpeechSynthesisVoice.speechVoices().first(where: { $0.language.contains(L10n.shared.language) && $0.gender == AVSpeechSynthesisVoiceGender.female })
        default:
				utterance.voice =
				AVSpeechSynthesisVoice.speechVoices().first(where: { $0.language.contains(L10n.shared.language) && $0.gender == AVSpeechSynthesisVoiceGender.female })
        }

        synthesizer.speak(utterance)
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

        return path
    }
}

 struct CircleFirstName_Previews: PreviewProvider {

     static var previews: some View {
         ForEach(ColorScheme.allCases, id: \.self) {
             Group {
        CircleFirstName(prenom: FirstnameDB())
            .previewDevice("iPhone 12 Pro Max")
            .previewDisplayName("iPhone 12 Pro Max")
             }.preferredColorScheme($0)

    }
 }
 }
