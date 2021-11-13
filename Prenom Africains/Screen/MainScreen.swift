//
//  MainScreen.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 22/03/2021.
//

import SwiftUI

struct MainScreen: View {

    @Environment(\.verticalSizeClass) var vSizeClass

    @Environment(\.horizontalSizeClass) var hSizeClass

    @EnvironmentObject var firstNameViewModel: FirstNameViewModel

    @Binding var searchString: NSCompoundPredicate

    @State private var currentColor = Color.gray

    @State private var currentIndex = 0

    @State private var count = 0

    @State var phaseCst: Double = 0

    let timer = Timer.publish(every: 0.01, on: .current, in: .common).autoconnect()

    var body: some View {

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
                Button {
                    self.firstNameViewModel.fetchOnline()
                } label: {
                    Image(systemName: "goforward")
                    Text("Tap to refresh")
                }.frame(
                    width: 200 * sizeMultiplier(vSizeClass, hSizeClass, regularConstant: 4.0),
                    height: 54 * sizeMultiplier(vSizeClass, hSizeClass, regularConstant: 4.0))
                LottieView(name: "noresults", loopMode: .playOnce)
                    .frame(
                        width: 54 * sizeMultiplier(vSizeClass, hSizeClass, regularConstant: 4.0),
                        height: 54 * sizeMultiplier(vSizeClass, hSizeClass, regularConstant: 4.0))
                Text("No firstnames")

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
                                width: 30 * CGFloat(sizeMultiplier(vSizeClass, hSizeClass, regularConstant: 4.0)),
                                height: 30 * CGFloat(sizeMultiplier(vSizeClass, hSizeClass, regularConstant: 4.0))
                            )
                        }
                        // iPad Full or 1/2
                        if vSizeClass == .regular && hSizeClass == .regular {
                            VStack {
                                Spacer()
                                CircleFirstName(prenom: firstNameViewModel.currentFirstname, color: setColor())
                                    .padding(.bottom)
                                    .frame(width: 600, height: 600)
                                Spacer()
                            }

                        } else {
                            CircleFirstName(prenom: firstNameViewModel.currentFirstname, color: setColor())
                                .padding(.bottom)
                        }

                        if isNextFirstname() {
                            rightButton()
                        } else {
                            Spacer().frame(
                                width: 30 * CGFloat(sizeMultiplier(vSizeClass, hSizeClass, regularConstant: 4.0)),
                                height: 30 * CGFloat(sizeMultiplier(vSizeClass, hSizeClass, regularConstant: 4.0))
                            )
                        }
                    }
                    if self.firstNameViewModel.isFiltered {
                        HStack {
                            Spacer()
                            FilterChip(text: "filters on", color: .white, action: {
                                self.firstNameViewModel.clearFilters()
                                self.firstNameViewModel.getFirstnames()
                            })
                                .padding(.horizontal)
                        }
                    }
                        DescriptionView()
                }
                .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
                            .onEnded { value in
                    let horizontalAmount = value.translation.width as CGFloat
                    let verticalAmount = value.translation.height as CGFloat

                    if abs(horizontalAmount) > abs(verticalAmount) {
                        print(horizontalAmount < 0 ? nextFirstname() : previousFirstname())
                    }
                })
                .padding(.vertical)
                .onAppear(perform: {
                    firstNameViewModel.onAppear()
                })
                .onReceive(firstNameViewModel.$firstnamesResults) { firstnames in
                    if let firstnames = firstnames {
                        if !firstnames.isEmpty {
                            firstNameViewModel.currentFirstname = firstnames[currentIndex]
                        }
                    }
                }
            }
        }
        }
    }

    // MARK: Previous & Next Buttons
    fileprivate func leftButton() -> some View {
        return Triangle()
            .fill(setColor())
            .frame(
                width: 30 * sizeMultiplier(vSizeClass, hSizeClass, regularConstant: 4.0),
                height: 30 * sizeMultiplier(vSizeClass, hSizeClass, regularConstant: 4.0))
            .padding(.bottom, 1 * CGFloat(paddingMultiplier()))
            .rotationEffect(.degrees(-90))
            .onTapGesture {
                previousFirstname()
            }
            .accessibility(label: Text("left button"))
    }

    fileprivate func rightButton() -> some View {
        return Triangle()
            .fill(setColor())
            .frame(
                width: 30 * sizeMultiplier(vSizeClass, hSizeClass, regularConstant: 4.0),
                height: 30 * sizeMultiplier(vSizeClass, hSizeClass, regularConstant: 4.0))
            .padding(.bottom, 1 * CGFloat(paddingMultiplier()))
            .rotationEffect(.degrees(90))
            .onTapGesture {
                nextFirstname()
            }
            .accessibility(label: Text("right button"))
    }

    fileprivate func isNextFirstname() -> Bool {
        if let firstnames = firstNameViewModel.firstnamesResults {
            return self.currentIndex < firstnames.count-1
        } else {
            return false
        }

    }

    fileprivate func nextFirstname() {
        if isNextFirstname() {
            if let firstnames = firstNameViewModel.firstnamesResults {
            self.currentIndex = currentIndex + 1
            firstNameViewModel.currentFirstname = firstnames[currentIndex]
            }
        }
    }

    fileprivate func isPreviousFirstname() -> Bool {
        return self.currentIndex > 0
    }

    fileprivate func previousFirstname() {
        if isPreviousFirstname() {
            if let firstnames = firstNameViewModel.firstnamesResults {
            self.currentIndex = currentIndex - 1
            firstNameViewModel.currentFirstname = firstnames[currentIndex]
            }
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

    func setColor() -> Color {
        switch firstNameViewModel.currentFirstname.gender {
        case Gender.male.rawValue:
            return Color.appBlue
        case Gender.female.rawValue:
            return Color.pink
        case Gender.mixed.rawValue:
            return Color.purple
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
            return Color.gray
        default:
            return Color.gray
        }
    }

}

 struct MainScreen_Previews: PreviewProvider {

    @State static var searchString = NSCompoundPredicate()

    static var previews: some View {

        ForEach(ColorScheme.allCases, id: \.self) {
        Group {
            MainScreen( searchString: $searchString)
                .previewDevice("iPhone 12")
                .previewDisplayName("iPhone 12")

            MainScreen(searchString: $searchString)
                .previewDevice("iPhone 8 Plus")
                .previewDisplayName("iPhone 8 Plus")

            MainScreen(searchString: $searchString)
                .previewDevice("iPhone 8")
                .previewDisplayName("iPhone 8")
        }.preferredColorScheme($0)
        }
    }
 }
