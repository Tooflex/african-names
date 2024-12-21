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
    @StateObject var viewModel: FirstNameViewModel
    @EnvironmentObject var contentViewModel: ContentViewModel
    @EnvironmentObject var adsViewModel: AdsViewModel
    
    @State private var engine: CHHapticEngine?
    @State private var currentIndex = 0
    @State private var phaseCst: Double = 0
    
    let timer = Timer.publish(every: 0.01, on: .current, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                loadingView
            } else if viewModel.noResults {
                noResultsView
            } else {
                mainContentView
            }
        }
        .contentShape(Rectangle())
        .gesture(swipeGesture)
        .onAppear(perform: onAppearActions)
        .onReceive(viewModel.$firstnames) { firstnames in
            if !firstnames.isEmpty {
                viewModel.currentFirstname = firstnames[currentIndex]
            }
        }
//        .onReceive(contentViewModel.$isLanguageChanged) { isLanguageChanged in
//            handleLanguageChange(isLanguageChanged)
//        }
    }
    
    private var loadingView: some View {
        VStack {
            Spacer()
            LottieView(name: "loading-rainbow", loopMode: .loop)
                .frame(width: 300 * sizeMultiplier(), height: 300 * sizeMultiplier())
            Text("Loading...")
            Spacer()
        }
    }
    
    private var noResultsView: some View {
        VStack {
            Spacer()
            if viewModel.noData {
                refreshButton
            }
            if viewModel.isFiltered {
                filterChip
            }
            LottieView(name: "noresults".l10n(), loopMode: .playOnce)
                .frame(width: 54 * sizeMultiplier(), height: 54 * sizeMultiplier())
            Text("No firstnames".l10n())
            Spacer()
        }
    }
    
    private var refreshButton: some View {
        Button {
            Task {
                await viewModel.fetchOnline()
            }
        } label: {
            HStack {
                Image(systemName: "goforward")
                Text("Tap to refresh")
            }
        }
        .frame(width: 200 * sizeMultiplier(), height: 54 * sizeMultiplier())
    }
    
    private var filterChip: some View {
        HStack {
            Spacer()
            FilterChip(text: "filters on".l10n(), color: .white) {
                Task {
                    viewModel.clearFilters()
                    await viewModel.loadFirstnames()
                }

            }
            .padding(.horizontal)
        }
    }
    
    private var mainContentView: some View {
        GeometryReader { geo in
            ZStack {
                waveBackground(in: geo)
                VStack {
                    Spacer()
                    HStack {
                        if isPreviousFirstname() { leftButton() } else { Spacer().frame(width: 30 * sizeMultiplierSpacer(), height: 30 * sizeMultiplierSpacer()) }
                        CircleFirstName(prenom: viewModel.currentFirstname ?? FirstnameDB(), color: setColor())
                            .padding(.bottom)
                        if isNextFirstname() { rightButton() } else { Spacer().frame(width: 30 * sizeMultiplierSpacer(), height: 30 * sizeMultiplierSpacer()) }
                    }
                    if viewModel.isFiltered {
                        filterChip.padding(.horizontal, 30 * sizeMultiplierSpacer())
                        Spacer(minLength: 30)
                    }
                    DescriptionView()
                }
                .padding(.vertical)
            }
        }
    }
    
    private func waveBackground(in geometry: GeometryProxy) -> some View {
        ZStack {
            Wave(waveHeight: 30, phase: Angle(degrees: (Double(geometry.frame(in: .global).minY) + phaseCst) * -1 * 0.7))
                .foregroundColor(setColorAlt())
                .opacity(0.5)
            Wave(waveHeight: 30, phase: Angle(degrees: (Double(geometry.frame(in: .global).minY) + phaseCst) * 0.7))
                .foregroundColor(setColor())
                .onReceive(self.timer) { _ in
                    phaseCst += 0.2
                }
        }
        .frame(height: 70, alignment: .center)
    }
    
    private func leftButton() -> some View {
        Triangle()
            .fill(setColor())
            .frame(width: 30 * sizeMultiplierTriangle(), height: 30 * sizeMultiplierTriangle())
            .padding(.bottom, 1 * CGFloat(paddingMultiplier()))
            .rotationEffect(.degrees(-90))
            .onTapGesture(perform: previousFirstname)
            .accessibility(label: Text("left button"))
    }
    
    private func rightButton() -> some View {
        Triangle()
            .fill(setColor())
            .frame(width: 30 * sizeMultiplierTriangle(), height: 30 * sizeMultiplierTriangle())
            .padding(.bottom, 1 * CGFloat(paddingMultiplier()))
            .rotationEffect(.degrees(90))
            .onTapGesture(perform: nextFirstname)
            .accessibility(label: Text("right button"))
    }
    
    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 20, coordinateSpace: .global)
            .onEnded { value in
                let horizontalAmount = value.translation.width
                let verticalAmount = value.translation.height
                if abs(horizontalAmount) > abs(verticalAmount) {
                    horizontalAmount < 0 ? nextFirstname() : previousFirstname()
                }
            }
    }
    
    private func onAppearActions() {
        prepareHaptics()
        if contentViewModel.isFirstLaunch {
            viewModel.onAppear()
        }
        contentViewModel.isFirstLaunch = false
    }
    
    private func handleLanguageChange(_ isLanguageChanged: Bool) {
        if isLanguageChanged && !contentViewModel.isFirstLaunch {
            print("Get firstnames after language changed")
            Task {
                await viewModel.fetchOnline()
            }
            contentViewModel.isFirstLaunch = false
        }
        contentViewModel.isLanguageChanged = false
    }
    
    private func isNextFirstname() -> Bool {
        currentIndex < viewModel.firstnames.count - 1
    }
    
    private func nextFirstname() {
        if isNextFirstname() {
            currentIndex += 1
            viewModel.currentFirstname = viewModel.firstnames[currentIndex]
            viewModel.incrementShowAdCounter(adsViewModel)
        } else {
            nomNomPattern()
        }
    }
    
    private func isPreviousFirstname() -> Bool {
        currentIndex > 0
    }
    
    private func previousFirstname() {
        if isPreviousFirstname() {
            currentIndex -= 1
            viewModel.currentFirstname = viewModel.firstnames[currentIndex]
            viewModel.incrementShowAdCounter(adsViewModel)
        } else {
            nomNomPattern()
        }
    }
    
    // MARK: - Haptics functions
    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error)")
        }
    }
    
    private func nomNomPattern() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            let pattern = try CHHapticPattern(events: [
                CHHapticEvent(eventType: .hapticContinuous, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
                ], relativeTime: 0, duration: 0.15),
                CHHapticEvent(eventType: .hapticContinuous, parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.4),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.1)
                ], relativeTime: 0.3, duration: 0.3)
            ], parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error).")
        }
    }
    
    // MARK: - Helper functions
    private func paddingMultiplier() -> Int {
        vSizeClass == .regular && hSizeClass == .regular ? 70 : 1
    }
    
    private func sizeMultiplier() -> CGFloat {
        vSizeClass == .regular && hSizeClass == .regular ? 4.0 : 1.0
    }
    
    private func sizeMultiplierTriangle() -> CGFloat {
        switch UIScreen.current {
        case .iPhone5_8, .iPhone5_5: return 1
        case .iPhone4_7: return 0.8
        case .iPad10_5: return UIDevice.current.orientation.isLandscape ? 0.5 : 1
        case .iPad10_9: return UIDevice.current.orientation.isLandscape ? 0.5 : 0.5
        case .iPad12_9: return 1
        default: return 1
        }
    }
    
    private func sizeMultiplierSpacer() -> CGFloat {
        switch UIScreen.current {
        case .iPhone5_8, .iPhone5_5: return 1
        case .iPhone4_7: return 0.8
        case .iPad10_5: return UIDevice.current.orientation.isLandscape ? 0.5 : 1
        case .iPad10_9: return UIDevice.current.orientation.isLandscape ? 0.5 : 0.1
        case .iPad12_9: return 1
        default: return 1
        }
    }
    
    private func setColor() -> Color {
        switch viewModel.currentFirstname?.gender {
        case Gender.male.rawValue: return Color("blue")
        case Gender.female.rawValue: return Color("pink")
        case Gender.mixed.rawValue: return Color("purple")
        default: return Color.black
        }
    }
    
    private func setColorAlt() -> Color {
        switch viewModel.currentFirstname?.gender {
        case Gender.male.rawValue: return Color.blue
        case Gender.female.rawValue: return Color.lightPink
        case Gender.mixed.rawValue: return Color.lightPurple
        default: return Color("gray")
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) { scheme in
            Group {
                MainScreen(viewModel: FirstNameViewModel(service: FirstNameService(repository: FirstNameRepository())))
                    .previewDevice("iPhone 12")
                    .previewDisplayName("iPhone 12")
                
                MainScreen(viewModel: FirstNameViewModel(service: FirstNameService(repository: FirstNameRepository())))
                    .previewDevice("iPhone 8 Plus")
                    .previewDisplayName("iPhone 8 Plus")
            }
            .preferredColorScheme(scheme)
            .environmentObject(ContentViewModel(service: FirstNameService(repository: FirstNameRepository()), filterService: FilterService()))
            .environmentObject(AdsViewModel())
        }
    }
}
