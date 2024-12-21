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
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.verticalSizeClass) var vSizeClass
    @Environment(\.horizontalSizeClass) var hSizeClass
    @EnvironmentObject var viewModel: FirstNameViewModel
    @State private var engine: CHHapticEngine?
    @State private var isShowPopoverOrigins = false
    @State private var isShowPopoverMeaning = false

    var body: some View {
        VStack {
            Spacer()
            meaningView
            Spacer()
            genderAndOriginView
            favoriteButton
            Spacer()
            ShareButton(firstname: Binding(
                get: { viewModel.currentFirstname ?? FirstnameDB() },
                set: { viewModel.currentFirstname = $0 }
            ))
            .opacity(0.8)
        }
        .onAppear(perform: prepareHaptics)
    }

    private var meaningView: some View {
        ZStack(alignment: .center) {
            meaningBackground
            meaningContent
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }

    private var meaningBackground: some View {
        RoundedRectangle(cornerRadius: 25, style: .continuous)
            .fill(colorScheme == .dark ? .white : Color.offWhite.opacity(0.71))
            .frame(width: UIScreen.main.bounds.width * 0.8, height: 165 * sizeMultiplierMeaningRectangle())
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
            .shadow(color: colorScheme == .dark ? Color.black.opacity(0.7) : Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
    }

    private var meaningContent: some View {
        let deviceLanguage = Locale.current.languageCode ?? "en"
        
        return VStack {
            Text(viewModel.currentFirstname?.getDisplayMeaning(deviceLanguage: deviceLanguage)
                .trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(.white)
            
            if let firstname = viewModel.currentFirstname,
                (firstname.getDisplayMeaning(deviceLanguage: deviceLanguage).count > 65 || !firstname.meaningMore.isEmpty) {
                Button("More...".l10n()) {
                    isShowPopoverMeaning.toggle()
                }
                .font(.callout)
                .foregroundColor(Color("black"))
                .padding(.bottom)
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.75)
        .popover(isPresented: $isShowPopoverMeaning) {
            PopoverView(
                text: viewModel.currentFirstname?.getDisplayMeaning(deviceLanguage: deviceLanguage) ?? "",
                textMore: viewModel.currentFirstname?.meaningMore ?? "")
        }
    }

    private var genderAndOriginView: some View {
        HStack {
            genderIcon
            Spacer()
            originText
        }
        .frame(alignment: .center)
    }

    private var genderIcon: some View {
        Group {
            switch viewModel.currentFirstname?.gender {
            case Gender.male.rawValue:
                genderImage("md-male")
            case Gender.female.rawValue:
                genderImage("md-female")
            case Gender.mixed.rawValue:
                HStack {
                    genderImage("md-male")
                    genderImage("md-female")
                }
            default:
                EmptyView()
            }
        }
    }

    private func genderImage(_ name: String) -> some View {
        Image(name)
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: 30 * sizeMultiplier(), height: 30 * sizeMultiplier())
            .padding(.top)
            .padding(.horizontal)
            .foregroundColor(.white)
    }

    private var originText: some View {
        Group {
            if let origins = viewModel.currentFirstname?.origins, !origins.isEmpty {
                if origins.count < 12 {
                    Text("Origins:".l10n() + " \(origins)")
                        .frame(width: 250, alignment: .trailing)
                        .font(.title2)
                        .lineLimit(1)
                        .padding(.top)
                        .padding(.horizontal)
                        .foregroundColor(.white)
                } else {
                    Button {
                        isShowPopoverOrigins.toggle()
                    } label: {
                        MarqueeTextView(text: "Origins:".l10n() + " \(origins)", font: UIFont.preferredFont(from: .title2), delayTime: 0)
                            .frame(width: 250, alignment: .trailing)
                            .lineLimit(1)
                            .padding(.top)
                            .padding(.horizontal)
                    }
                    .foregroundColor(.white)
                    .popover(isPresented: $isShowPopoverOrigins) {
                        PopoverView(
                            title: LocalizedStringKey("Origins"),
                            text: origins,
                            textMore: origins
                        )
                    }
                }
            }
        }
    }

    private var favoriteButton: some View {
        Button(action: {
            Task { @MainActor in
                await viewModel.toggleFavorited(firstname: viewModel.currentFirstname ?? FirstnameDB())
                complexSuccess()
            }
        }) {
            LottieView(
                name: getRightHeartLikeStyle(gender: Gender(rawValue: viewModel.currentFirstname?.gender ?? "") ?? .undefined),
                fromMarker: (viewModel.currentFirstname?.isFavorite ?? false) ? "touchDownStart" : "touchDownStart1",
                toMarker: (viewModel.currentFirstname?.isFavorite ?? false) ? "touchUpEnd" : "touchUpEnd1"
            )
            .padding(.all, -40)
            .frame(width: 40 * sizeMultiplier(), height: 40 * sizeMultiplier(), alignment: .center)
        }
    }

    private func getRightHeartLikeStyle(gender: Gender) -> String {
        gender == .female ? "heart_like_white" : "heart_like"
    }

    private func sizeMultiplier() -> CGFloat {
        vSizeClass == .regular && hSizeClass == .regular ? 2 : 0.8
    }

    private func sizeMultiplierMeaningRectangle() -> CGFloat {
        switch UIScreen.current {
        case .iPhone5_8: return 1
        case .iPhone5_5: return 0.8
        case .iPhone4_7: return 0.5
        case .iPad10_5: return UIDevice.current.orientation.isLandscape ? 0.5 : 1.2
        case .iPad12_9: return 1
        default: return 1
        }
    }

    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error)")
        }
    }

    private func complexSuccess() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            let pattern = try CHHapticPattern(events: [
                CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 1),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
                ], relativeTime: 0),
                CHHapticEvent(eventType: .hapticTransient, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 1),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
                ], relativeTime: 0.1)
            ], parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error).")
        }
    }
}

struct DescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            Group {
                DescriptionView()
                    .previewDevice("iPhone 12 Pro Max")
                    .previewDisplayName("iPhone 12 Pro Max")
            }
            .preferredColorScheme(scheme)
            .environmentObject(FirstNameViewModel(service: FirstNameService(repository: FirstNameRepository())))
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
