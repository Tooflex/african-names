//
//  CircleFirstName.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 22/03/2021.
//

import SwiftUI
import AVFoundation

struct CircleFirstName: View {
    
    @Environment(\.verticalSizeClass) var vSizeClass
    
    @Environment(\.horizontalSizeClass) var hSizeClass
    
    var prenom: PrenomAF
    var color: Color = .blue
    
    var body: some View {
        VStack {
                ZStack {
                    Circle()
                        .fill(color)
                        .frame(width: 300 * sizeMultiplier(), height: 300 * sizeMultiplier())
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    VStack {
                        Text(prenom.firstname ?? "")
                            .foregroundColor(.white)
                            .font(.system(size: 60 * CGFloat(sizeMultiplier())))
                            .offset(y:40)
                            .shadow(color: Color.black.opacity(16.0), radius: 6, x: 5, y: 3)
                        
                        Button(action: {
                            speakFirstname(firsnameStr: prenom.firstname ?? "")
                        }) {
                            LottieView(name: "sound", loopMode: .loop)
                                .frame(width: 54 * sizeMultiplier(), height: 54 * sizeMultiplier())
                        }.offset(y: 50)
                    }
                }
        }
    }
    
    func sizeMultiplier() -> CGFloat {
        if vSizeClass == .regular && hSizeClass == .regular {
            return 2.2
        } else {
            return 1
        }
    }
    
    func speakFirstname(firsnameStr: String) {
        let utterance = AVSpeechUtterance(string: firsnameStr)

        
        switch prenom.gender {
        case Gender.male:
            utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_male_fr-FR_compact")
        default:
            utterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_female_fr-FR_compact")
        }
        
        let synthesizer = AVSpeechSynthesizer()
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

//struct CircleFirstName_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        CircleFirstName(prenom: firstnames[0])
//    }
//}
