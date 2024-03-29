//
//  DescriptionView.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 22/03/2021.
//

import SwiftUI
import CoreHaptics
import L10n_swift
import Firebase
import FirebaseAnalytics

struct DescriptionView: View {
    @Environment(\.colorScheme) var currentMode
    @Environment(\.verticalSizeClass) var vSizeClass
    @Environment(\.horizontalSizeClass) var hSizeClass

    @EnvironmentObject var firstNameViewModel: FirstNameViewModel

    @State private var engine: CHHapticEngine?

    @State var isShowPopoverOrigins: Bool = false
    @State var isShowPopoverMeaning: Bool = false

    var body: some View {
        VStack {
            Spacer()
            GeometryReader { geometry in
                HStack(alignment: .center) {
                    Spacer()
                ZStack {
                    if currentMode == .dark {
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(.thickMaterial)
                            .frame(
                                width: UIScreen.main.bounds.width - 50,
                                height: 165 * sizeMultiplierMeaningRectangle(),
                                alignment: .center)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.black.opacity(0.7), radius: 10, x: -5, y: -5)
                    } else {
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(Color.offWhite.opacity(0.71))
                            .frame(
                                width: UIScreen.main.bounds.width - 50,
                                height: 165 * sizeMultiplierMeaningRectangle(),
                                alignment: .center)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    }

                    // MARK: Meaning text
					if firstNameViewModel.currentFirstname.meaning.count > 65
						|| firstNameViewModel.currentFirstname.meaningMore.count > 0 {
						ZStack(alignment: .bottomTrailing) {
							Text(firstNameViewModel.currentFirstname.meaning.trimmingCharacters(in: .whitespacesAndNewlines))
								.font(.title2)
								.multilineTextAlignment(.center)
								.frame(
									width: UIScreen.main.bounds.width * 0.8,
									height: 100 * sizeMultiplier(),
									alignment: .center)
								.foregroundColor(.white)
							Button {
								print("Tapped")
								isShowPopoverMeaning.toggle()
							} label: {
								Text("More...".l10n())
									.font(/*@START_MENU_TOKEN@*/.callout/*@END_MENU_TOKEN@*/)
									.fontWeight(.bold)
									.foregroundColor(Color("black"))
									.padding([.top])
									.offset(x: 0, y: 25)
							}
						}
                    .popover(isPresented: $isShowPopoverMeaning) {
                        PopoverView(
							text: firstNameViewModel.currentFirstname.meaning,
							textMore: "\(firstNameViewModel.currentFirstname.meaningMore)")
						.onAppear {
							Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
								AnalyticsParameterItemID: firstNameViewModel.currentFirstname.id,
								AnalyticsParameterContentType: "name meaning"
							])
						}
                    }
					} else {
							Text(firstNameViewModel.currentFirstname.meaning.trimmingCharacters(in: .whitespacesAndNewlines))
								.font(.title2)
								.multilineTextAlignment(.center)
								.frame(
									width: UIScreen.main.bounds.width * 0.8,
									height: 100 * sizeMultiplier(),
									alignment: .center)
								.foregroundColor(.white)
					}

                }
                    Spacer()
                }
                .padding(.horizontal)
                .frame(idealWidth: geometry.size.width * 0.8 * sizeMultiplier(), maxHeight: geometry.size.height * sizeMultiplier(), alignment: .center)
            }

            Spacer()

            HStack {
                // MARK: Gender Icons
                switch firstNameViewModel.currentFirstname.gender {
                case Gender.male.rawValue:
                HStack {
                    Image("md-male")
                        .renderingMode(.template)
                        .resizable()
                        .frame(
                            width: 30 * sizeMultiplier(),
                            height: 30 * sizeMultiplier(),
                            alignment: .center)
						.padding(.top)
						.padding(.horizontal)
                        .foregroundColor(Color.white)
                }

                case Gender.female.rawValue:
                HStack {
                    Image("md-female")
                        .resizable()
                        .frame(
                            width: 30 * sizeMultiplier(),
                            height: 30 * sizeMultiplier(),
                            alignment: .center)
						.padding(.top)
						.padding(.horizontal)
                        .foregroundColor(Color.white)
                }
                case Gender.mixed.rawValue:
                HStack {
                    Image("md-male")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: 30 * sizeMultiplier(),
                            height: 30 * sizeMultiplier(),
                            alignment: .center)
						.padding(.top)
						.padding(.horizontal)
                        .foregroundColor(Color.white)

                    Image("md-female")
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: 30 * sizeMultiplier(),
                            height: 30 * sizeMultiplier(),
                            alignment: .center)
						.padding(.top)
                        .foregroundColor(Color.white)
                }
                case Gender.undefined.rawValue:
                EmptyView()
                        .frame(
                            width: 30 * sizeMultiplier(),
                            height: 30 * sizeMultiplier(),
                            alignment: .center)
                default:
                    EmptyView()
                        .frame(
                            width: 30 * sizeMultiplier(),
                            height: 30 * sizeMultiplier(),
                            alignment: .center)
                }

                Spacer()
                // MARK: Origin Text
                if firstNameViewModel.currentFirstname.origins.count < 12 {
					if !firstNameViewModel.currentFirstname.origins.isEmpty {
						Text("Origins:".l10n() + " \(firstNameViewModel.currentFirstname.origins)")
							.frame(width: 250, alignment: .trailing)
							.font(.title2)
							.lineLimit(1)
							.padding(.top)
							.padding(.horizontal)
							.foregroundColor(.white)
					}
                } else {
                    Button {
                        print("Tapped")
                        isShowPopoverOrigins.toggle()
                    } label: {
						MarqueeTextView(text: "Origins:".l10n() + " \(firstNameViewModel.currentFirstname.origins)", font: UIFont.preferredFont(from: .title2), delayTime: 0)
                            .frame(width: 250, alignment: .trailing)
                            .lineLimit(1)
							.padding(.top)
                            .padding(.horizontal)
                    }
                    .foregroundColor(.white)
                    .popover(isPresented: $isShowPopoverOrigins) {
                        PopoverView(
                            title: LocalizedStringKey("Origins"),
							text: "\(firstNameViewModel.currentFirstname.origins)",
                            textMore: "\(firstNameViewModel.currentFirstname.origins)"
						)
                    }
                }

            }
            .frame(alignment: .center)

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
                                    width: 40 * sizeMultiplier(),
                                    height: 40 * sizeMultiplier(),
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
                                    width: 40 * sizeMultiplier(),
                                    height: 40 * sizeMultiplier(),
                                    alignment: .center)
                        }
                    }
                }.frame(alignment: .center)
            Spacer()
            HStack(alignment: .center) {
                // MARK: Share Button
                ShareButton(firstname: $firstNameViewModel.currentFirstname)
                    .opacity(0.8)

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

    func sizeMultiplier() -> CGFloat {
        if vSizeClass == .regular && hSizeClass == .regular {
            return 2
        } else {
			return 0.8
        }
    }

    func sizeMultiplierMeaningRectangle() -> CGFloat {
        // Check for a specific model
        if UIScreen.current == .iPhone5_8 {
            return 1
        }

		if UIScreen.current == .iPhone5_5 {
			return 0.8
		}

        // Check for multiple models
        if UIScreen.current == .iPhone4_7 {
            return 0.5
        }

        // Find all models larger than or equal to a certain screen size
        if UIScreen.current == .iPad10_5 {
            if UIDevice.current.orientation.isLandscape {
                return 0.5
            } else {
                return 1.2
            }
        }

        if UIScreen.current == .iPad12_9 {
            return 1
        }

        return 1
    }

	func registerFavoriteEvent() {

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

struct FrameAdjustingContainer<Content: View>: View {
    @Binding var frameWidth: CGFloat
    @Binding var frameHeight: CGFloat
    let content: () -> Content

    var body: some View {
        ZStack {
            content()
                .frame(width: frameWidth, height: frameHeight)
                .border(Color.red, width: 1)

            VStack {
                Spacer()
                Slider(value: $frameWidth, in: 50...300)
                Slider(value: $frameHeight, in: 50...600)
            }
            .padding()
        }
    }
}

extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
    static let appBlue = Color(red: 5/255, green: 59/255, blue: 151/255)
    static let lightPink = Color(red: 150/255, green: 71/255, blue: 76/255)
    static let lightPurple = Color(red: 255/255, green: 182/255, blue: 193/255)
    static let darkPink = Color(red: 219, green: 71, blue: 147)
    static let darkPurple = Color(red: 133, green: 96, blue: 136)
}

 struct DescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            Group {
//                DescriptionView()
//                    .previewDevice("iPad Pro (12.9-inch) (4th generation)")
//                    .previewDisplayName("iPad Pro 12")
//                    .landscape()

                DescriptionView()
                    .previewDevice("iPhone 8")
                    .previewDisplayName("iPhone 8")

                DescriptionView()
                    .previewDevice("iPhone 12 Pro Max")
                    .previewDisplayName("iPhone 12 Pro Max")
            }.preferredColorScheme($0).environmentObject(FirstNameViewModel())
        }

    }
 }
