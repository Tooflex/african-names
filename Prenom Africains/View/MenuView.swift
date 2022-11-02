//
//  MenuView.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 22/03/2021.
//

import SwiftUI
import L10n_swift

struct MenuView: View {

    @Environment(\.colorScheme) var currentMode

    @Environment(\.verticalSizeClass) var vSizeClass

    @Environment(\.horizontalSizeClass) var hSizeClass

    @Binding var selectedTab: Tab

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .frame(width: 360 * CGFloat(sizeMultiplier()), height: 80, alignment: .center)
                .foregroundColor(currentMode == .dark ? Color("offWhite") : Color("offWhite").opacity(0.7))
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                .shadow(color: currentMode == .dark ? Color.black.opacity(0.7) : Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
            HStack(alignment: .center, spacing: 35.0 * CGFloat(sizeMultiplier())) {

                // MARK: Home Button
                HomeButton(selectedTab: $selectedTab)

                // MARK: Search Button
                SearchButton(selectedTab: $selectedTab)

                // MARK: List Button
                MyListButton(selectedTab: $selectedTab)

                // MARK: Parameter Button
                ParameterButton(selectedTab: $selectedTab)
            }
        }
    }

    struct HomeButton: View {
        @Binding var selectedTab: Tab

        let iconFont = Font.system(size: 27).bold()
        let textFont = Font.system(size: 12)

        var body: some View {
            Button(action: {
                self.selectedTab = .home
            }) {
                VStack(alignment: .center, spacing: 3) {
                    Image(systemName: "house")
                        .font(iconFont)
                        .foregroundColor(selectedTab == .home ? Color("blue") : Color("black"))
                        .accessibilityLabel(Text("Home".l10n()))
                    Text("Home".l10n()).font(textFont)
                        .foregroundColor(selectedTab == .home ? Color("blue") : Color("black"))
                }
            }
        }
    }

    struct SearchButton: View {
        @Binding var selectedTab: Tab

        let iconFont = Font.system(size: 27).bold()
        let textFont = Font.system(size: 12)

        var body: some View {
            Button(action: {
                self.selectedTab = .search
            }) {
                VStack(alignment: .center, spacing: 3) {
                    Image(systemName: "magnifyingglass")
                        .font(iconFont)
                        .foregroundColor(selectedTab == .search ? Color("blue") : Color("black"))
                        .accessibilityLabel(Text("Search".l10n()))
                    Text("Search".l10n()).font(textFont)
                        .foregroundColor(selectedTab == .search ? Color("blue") : Color("black"))
                }
            }
        }
    }

    struct MyListButton: View {

        @Binding var selectedTab: Tab

        let iconFont = Font.system(size: 27).bold()
        let textFont = Font.system(size: 12)

        var body: some View {
            Button(action: {
                self.selectedTab = .list
            }, label: {
                VStack(alignment: .center, spacing: 3) {
                    Image(systemName: "bookmark")
                        .font(iconFont)
                        .foregroundColor(selectedTab == .list ? Color("blue") : Color("black"))
                        .accessibilityLabel(Text("My List".l10n()))
                    Text("My List".l10n()).font(textFont)
                        .foregroundColor(selectedTab == .list ? Color("blue") : Color("black"))
                        .accessibilityLabel(Text("My List"))

                }
            })
        }
    }

    struct ParameterButton: View {

        @Binding var selectedTab: Tab

        let iconFont = Font.system(size: 27).bold()
        let textFont = Font.system(size: 12)

        var body: some View {
            Button(action: {
                self.selectedTab = .param
            }, label: {
                VStack(alignment: .center, spacing: 3) {
                    Image(systemName: "gearshape")
                        .font(iconFont)
                        .foregroundColor(selectedTab == .param ? Color("blue") : Color("black"))
                        .accessibilityLabel(Text("Params".l10n()))
                    Text("Params".l10n())
                        .font(textFont)
                        .foregroundColor(
                            selectedTab == .param ? Color("blue") : Color("black"))
                }
            })
        }

    }

    func sizeMultiplier() -> Int {
        if vSizeClass == .regular && hSizeClass == .regular {
            return 2
        } else {
            return 1
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
		MenuView(selectedTab: .constant(.home))
            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
            .previewDisplayName("iPhone 12")

		MenuView(selectedTab: .constant(.home))
            .previewDevice(PreviewDevice(rawValue: "iPad 12"))
            .previewDisplayName("iPad 12")
    }
}
