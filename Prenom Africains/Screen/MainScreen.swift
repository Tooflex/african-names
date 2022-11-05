//
//  MainScreen.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 22/03/2021.
//

import SwiftUI
import L10n_swift
import CoreHaptics

struct MainScreen: View {

    @Environment(\.verticalSizeClass) var vSizeClass

    @Environment(\.horizontalSizeClass) var hSizeClass

    @Environment(\.colorScheme) var currentMode

    @EnvironmentObject var firstNameViewModel: FirstNameViewModel

	@EnvironmentObject var adsViewModel: AdsViewModel

    @State private var engine: CHHapticEngine?

    @State private var currentColor = Color.gray

    @State private var currentIndex = 0

    @State private var count = 0

    @State var phaseCst: Double = 0

    let timer = Timer.publish(every: 0.01, on: .current, in: .common).autoconnect()

    var body: some View {

        VStack {
            if self.firstNameViewModel.isLoading {
                VStack {
                    Spacer()
                    LottieView(name: "loading-rainbow", loopMode: .loop)
                        .frame(
                            width: 300 * CGFloat(sizeMultiplier(vSizeClass, hSizeClass, regularConstant: 4.0)),
                            height: 300 * CGFloat(sizeMultiplier(vSizeClass, hSizeClass, regularConstant: 4.0)))
                    Text("Loading...")
                    Spacer()
                }
            } else if self.firstNameViewModel.noResults {
                VStack {
                    Spacer()
                    if self.firstNameViewModel.noData {
                        Button {
                            self.firstNameViewModel.fetchOnline()
                        } label: {
                            Image(systemName: "goforward")
                            Text("Tap to refresh")
                        }.frame(
                            width: 200 * sizeMultiplier(vSizeClass, hSizeClass, regularConstant: 4.0),
                            height: 54 * sizeMultiplier(vSizeClass, hSizeClass, regularConstant: 4.0))
                    }

                    if self.firstNameViewModel.isFiltered {
                        HStack {
                            Spacer()
                            FilterChip(text: "filters on".l10n(), color: .white, action: {
                                self.firstNameViewModel.clearFilters()
                                self.firstNameViewModel.getFirstnames()
                            })
                                .padding(.horizontal)
                        }
                    }

                    LottieView(name: "noresults".l10n(), loopMode: .playOnce)
                        .frame(
                            width: 54 * sizeMultiplier(vSizeClass, hSizeClass, regularConstant: 4.0),
                            height: 54 * sizeMultiplier(vSizeClass, hSizeClass, regularConstant: 4.0))
                    Text("No firstnames".l10n())

                    Spacer()
                }
            } else {
                GeometryReader { geo in
                    ZStack {
                        ZStack {
                            Wave(
                                waveHeight: 30,
                                phase: Angle(degrees: (Double(geo.frame(in: .global).minY) + phaseCst) * -1 * 0.7))
                                .foregroundColor(setColorAlt())
                                .opacity(0.5)
                            Wave(
                                waveHeight: 30,
                                phase: Angle(degrees: (Double(geo.frame(in: .global).minY) + phaseCst) * 0.7))
                                .foregroundColor(setColor())
                                .onReceive(self.timer) { _ in
                                    phaseCst += 0.2
                                    count += 1
                                    if count > 5000 {
                                        self.timer.upstream.connect().cancel()
                                    }
                                }
                        }.frame(height: 70, alignment: .center)

                        VStack {
                            Spacer()
                            HStack {
                                if isPreviousFirstname() {
                                    leftButton()
                                } else {
                                    Spacer().frame(
                                        width: 30 * sizeMultiplierSpacer(),
                                        height: 30 * sizeMultiplierSpacer()
                                    )
                                }

                                CircleFirstName(prenom: firstNameViewModel.currentFirstname, color: setColor())
                                    .padding(.bottom)

                                if isNextFirstname() {
                                    rightButton()
                                } else {
                                    Spacer().frame(
                                        width: 30 * sizeMultiplierSpacer(),
                                        height: 30 * sizeMultiplierSpacer()
                                    )
                                }
                            }
                            if self.firstNameViewModel.isFiltered {
                                HStack {
                                    Spacer()
                                    FilterChip(text: "filters on".l10n(), color: .white, action: {
                                        self.firstNameViewModel.clearFilters()
                                        self.firstNameViewModel.getFirstnames()
                                    })
                                        .padding(.horizontal)
                                }
                            }
                            DescriptionView()
                        }
                        .padding(.vertical)
                    }
                }
            }
        }
        .contentShape(Rectangle())
        .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
                    .onEnded { value in
            let horizontalAmount = value.translation.width as CGFloat
            let verticalAmount = value.translation.height as CGFloat

            if abs(horizontalAmount) > abs(verticalAmount) {
                print(horizontalAmount < 0 ? nextFirstname() : previousFirstname())
            }
        })
        .onAppear(perform: {
            prepareHaptics()
            firstNameViewModel.onAppear()
        })
        .onReceive(firstNameViewModel.$firstnamesResults) { firstnames in
                if !firstnames.isEmpty {
                    firstNameViewModel.currentFirstname = firstnames[currentIndex]
                }
        }
//		.presentInterstitialAd(isPresented: $firstNameViewModel.showIntersitialAd, adUnitId: "ca-app-pub-3940256099942544/4411468910")
    }

    // MARK: Previous & Next Buttons
    fileprivate func leftButton() -> some View {
        return Triangle()
            .fill(setColor())
            .frame(
                width: 30 * sizeMultiplierTriangle(),
                height: 30 * sizeMultiplierTriangle())
            .padding(.bottom, 1 * CGFloat(paddingMultiplier()))
            .rotationEffect(.degrees(-90))
            .onTapGesture {
                previousFirstname()
            }
            .accessibility(label: Text("left button".l10n()))
    }

    fileprivate func rightButton() -> some View {
        return Triangle()
            .fill(setColor())
            .frame(
                width: 30 * sizeMultiplierTriangle(),
                height: 30 * sizeMultiplierTriangle())
            .padding(.bottom, 1 * CGFloat(paddingMultiplier()))
            .rotationEffect(.degrees(90))
            .onTapGesture {
                nextFirstname()
            }
            .accessibility(label: Text("right button".l10n()))
    }

    fileprivate func isNextFirstname() -> Bool {

            return self.currentIndex < firstNameViewModel.firstnamesResults.count-1
    }

    fileprivate func nextFirstname() {
        if isNextFirstname() {
            self.currentIndex = currentIndex + 1
            firstNameViewModel.currentFirstname = firstNameViewModel.firstnamesResults[currentIndex]
			firstNameViewModel.incrementShowAdCounter(adsViewModel)
        } else {
            nomNomPattern()
        }
    }

    fileprivate func isPreviousFirstname() -> Bool {
        return self.currentIndex > 0
    }

    fileprivate func previousFirstname() {
        if isPreviousFirstname() {
            self.currentIndex = currentIndex - 1
            firstNameViewModel.currentFirstname = firstNameViewModel.firstnamesResults[currentIndex]
			firstNameViewModel.incrementShowAdCounter(adsViewModel)
        } else {
            nomNomPattern()
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

    private func nomNomPattern() {
        let rumble1 = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
            ],
            relativeTime: 0,
            duration: 0.15)

        let rumble2 = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.4),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.1)
            ],
            relativeTime: 0.3,
            duration: 0.3)

        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: [rumble1, rumble2], parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error).")
        }
    }

    // MARK: Helpers
    func paddingMultiplier() -> Int {
        if vSizeClass == .regular && hSizeClass == .regular {
            return 70
        } else {
            return 1
        }
    }

    func sizeMultiplierTriangle() -> CGFloat {
        // Check for a specific model
        if UIScreen.current == .iPhone5_8 || UIScreen.current == .iPhone5_5 {
            return 1
        }

        // Check for multiple models
        if UIScreen.current == .iPhone4_7 {
            return 0.8
        }

        // Find all models larger than or equal to a certain screen size
        if UIScreen.current == .iPad10_5 {
            if UIDevice.current.orientation.isLandscape {
                return 0.5
            } else {
                return 1
            }
        }

        if UIScreen.current == .iPad10_9 {
            if UIDevice.current.orientation.isLandscape {
                return 0.5
            } else {
                return 0.5
            }
        }

        if UIScreen.current == .iPad12_9 {
            return 1
        }

        return 1
    }

    func sizeMultiplierSpacer() -> CGFloat {
        // Check for a specific model
        if UIScreen.current == .iPhone5_8 || UIScreen.current == .iPhone5_5 {
            return 1
        }

        // Check for multiple models
        if UIScreen.current == .iPhone4_7 {
            return 0.8
        }

        // Find all models larger than or equal to a certain screen size
        if UIScreen.current == .iPad10_5 {
            if UIDevice.current.orientation.isLandscape {
                return 0.5
            } else {
                return 1
            }
        }

        if UIScreen.current == .iPad10_9 {
            if UIDevice.current.orientation.isLandscape {
                return 0.5
            } else {
                return 0.1
            }
        }

        if UIScreen.current == .iPad12_9 {
            return 1
        }

        return 1
    }

    func setColor() -> Color {
        switch firstNameViewModel.currentFirstname.gender {
        case Gender.male.rawValue:
            return Color("blue")
        case Gender.female.rawValue:
                return Color("pink")
        case Gender.mixed.rawValue:
            return Color("purple")
        case Gender.undefined.rawValue:
            return Color.black
        default:
            return Color.black
        }
    }

    func setColorAlt() -> Color {
        switch firstNameViewModel.currentFirstname.gender {
        case Gender.male.rawValue:
            return Color.blue
        case Gender.female.rawValue:
            return Color.lightPink
        case Gender.mixed.rawValue:
            return Color.lightPurple
        case Gender.undefined.rawValue:
            return Color("gray")
        default:
            return Color("gray")
        }
    }

}

 struct MainScreen_Previews: PreviewProvider {

    static var previews: some View {

        ForEach(ColorScheme.allCases, id: \.self) {
        Group {
            MainScreen()
                .previewDevice("iPhone 12")
                .previewDisplayName("iPhone 12")

            MainScreen()
                .previewDevice("iPhone 8")
                .previewDisplayName("iPhone 8")
        }.preferredColorScheme($0)
                .environmentObject(FirstNameViewModel())
        }
    }

 }
