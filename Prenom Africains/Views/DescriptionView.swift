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
                Text("Origins: \(firstNameViewModel.currentFirstname.origins)")
                    .font(.title2)
                    .lineLimit(1)
                    .padding(.horizontal)
            }.frame(alignment: .center)

            if firstNameViewModel.currentFirstname.isFavorite {
                Button(action: {
                    firstNameViewModel.toggleFavorited(firstnameObj: firstNameViewModel.currentFirstname)
                }) {
                    LottieView(name: "heart_like", fromMarker: "touchDownStart", toMarker: "touchUpEnd")
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
                    LottieView(name: "heart_like", fromMarker: "touchDownStart1", toMarker: "touchUpEnd1")
                        .padding(.all, -40)
                        .frame(
                            width: 40 * CGFloat(sizeMultiplier()),
                            height: 40 * CGFloat(sizeMultiplier()),
                            alignment: .center)
                }
            }
            Spacer()
        }
        .onAppear(perform: prepareHaptics)

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
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }

    func complexSuccess() {
        print("haptic")
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
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
}

extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
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
