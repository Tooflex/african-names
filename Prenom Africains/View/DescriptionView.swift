//
//  DescriptionView.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 22/03/2021.
//

import SwiftUI
import CoreHaptics

struct DescriptionView: View {
    @Environment(\.verticalSizeClass) var vSizeClass

    @Environment(\.horizontalSizeClass) var hSizeClass

    @EnvironmentObject var firstNameViewModel: FirstNameViewModel

    @State private var engine: CHHapticEngine?

    var body: some View {
        VStack {
            Spacer()
            GeometryReader { geometry in
                HStack(alignment: .center) {
                    Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(Color.offWhite.opacity(0.71))
                        .frame(
                            width: UIScreen.main.bounds.width - 50,
                            height: 165 * CGFloat(sizeMultiplier()),
                            alignment: .center)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    Text(firstNameViewModel.currentFirstname.meaning)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .frame(
                            width: UIScreen.main.bounds.width * 0.8,
                            height: 100 * CGFloat(sizeMultiplier()),
                            alignment: .center)
                }
                    Spacer()
                }
                .padding(.horizontal)
                .frame(idealWidth: geometry.size.width * 0.8, maxHeight: geometry.size.height, alignment: .center)
            }

            HStack {
                // MARK: Gender Icons
                switch firstNameViewModel.currentFirstname.gender {
                case Gender.male.rawValue:
                HStack {
                    Image("md-male")
                        .resizable()
                        .frame(
                            width: 30 * CGFloat(sizeMultiplier()),
                            height: 30 * CGFloat(sizeMultiplier()),
                            alignment: .center)
                }

                case Gender.female.rawValue:
                HStack {
                    Image("md-female")
                        .resizable()
                        .frame(
                            width: 30 * CGFloat(sizeMultiplier()),
                            height: 30 * CGFloat(sizeMultiplier()),
                            alignment: .center)
                }
                case Gender.mixed.rawValue:
                HStack {
                    Image("md-male")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: 30 * CGFloat(sizeMultiplier()),
                            height: 30 * CGFloat(sizeMultiplier()),
                            alignment: .center)
                    Image("md-female")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: 30 * CGFloat(sizeMultiplier()),
                            height: 30 * CGFloat(sizeMultiplier()),
                            alignment: .center)
                }
                case Gender.undefined.rawValue:
                EmptyView()
                        .frame(
                            width: 30 * CGFloat(sizeMultiplier()),
                            height: 30 * CGFloat(sizeMultiplier()),
                            alignment: .center)
                default:
                    EmptyView()
                        .frame(
                            width: 30 * CGFloat(sizeMultiplier()),
                            height: 30 * CGFloat(sizeMultiplier()),
                            alignment: .center)
                }

                Spacer()
                // MARK: Origin Text
                Text("Origins: \(firstNameViewModel.currentFirstname.origins)")
                    .font(.title2)
                    .lineLimit(1)
                    .padding(.horizontal)
            }.frame(alignment: .center)

            HStack(alignment: .center) {
                    // MARK: Favorite Button
                    if firstNameViewModel.currentFirstname.isFavorite {
                        Button(action: {
                            firstNameViewModel.toggleFavorited(firstnameObj: firstNameViewModel.currentFirstname)
                        }) {
                            LottieView(
                                name:
                                    getRightHeartLikeStyle(
                                        gender:
                                            Gender(rawValue:
                                                    firstNameViewModel.currentFirstname.gender) ?? Gender.undefined),
                                fromMarker: "touchDownStart",
                                toMarker: "touchUpEnd")
                                .padding(.all, -40)
                                .frame(
                                    width: 40 * CGFloat(sizeMultiplier()),
                                    height: 40 * CGFloat(sizeMultiplier()),
                                    alignment: .center)
                        }
                    } else {
                        Button(action: {
                            firstNameViewModel.toggleFavorited(firstnameObj: firstNameViewModel.currentFirstname)
                            complexSuccess()
                        }) {
                            LottieView(
                                name:
                                    getRightHeartLikeStyle(
                                        gender: Gender(rawValue:
                                                        firstNameViewModel.currentFirstname.gender) ?? Gender.undefined),
                                fromMarker: "touchDownStart1",
                                toMarker: "touchUpEnd1")
                                .padding(.all, -40)
                                .frame(
                                    width: 40 * CGFloat(sizeMultiplier()),
                                    height: 40 * CGFloat(sizeMultiplier()),
                                    alignment: .center)
                        }
                    }
                }.frame(alignment: .center)
            Spacer()
            HStack(alignment: .center) {
                // MARK: Share Button
                ShareButton().opacity(0.8)
            }
        }
        .onAppear(perform: prepareHaptics)
    }

    func getRightHeartLikeStyle(gender: Gender) -> String {
        switch gender {
        case Gender.female:
               return "heart_like_white"
        default:
              return "heart_like"
        }
    }

    func sizeMultiplier() -> Int {
        if vSizeClass == .regular && hSizeClass == .regular {
            return 2
        } else {
            return 1
        }
    }

    // MARK: Haptics functions
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error)")
        }
    }

    func complexSuccess() {
        // make sure that the device supports haptics
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        // Double tap
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        let intensity1 = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness1 = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        let event1 = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity1, sharpness1], relativeTime: 0.1)
        events.append(event)
        events.append(event1)

        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error).")
        }
    }

}

extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
    static let appBlue = Color(red: 5/255, green: 59/255, blue: 151/255)
    static let lightPink = Color(red: 150/255, green: 71/255, blue: 76/255)
    static let lightPurple = Color(red: 255/255, green: 182/255, blue: 193/255)
}

struct DescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            Group {
                DescriptionView()
                    .previewDevice("iPad Pro (12.9-inch) (4th generation)")
                    .previewDisplayName("iPad Pro 12")
                    .landscape()

                DescriptionView()
                    .previewDevice("iPhone 12 Pro Max")
                    .previewDisplayName("iPhone 12 Pro Max")
            }.preferredColorScheme($0)
        }

    }
}
