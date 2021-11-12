//
//  MenuView.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 22/03/2021.
//

import SwiftUI

struct MenuView: View {

    @Environment(\.verticalSizeClass) var vSizeClass

    @Environment(\.horizontalSizeClass) var hSizeClass

    @Binding var selectedTab: Int

    @State private var showShareSheet: Bool = false

    @State var shareSheetItems: [Any] = []

    var excludedActivityTypes: [UIActivity.ActivityType]?

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .frame(width: 360 * CGFloat(sizeMultiplier()), height: 80, alignment: .center)
                .foregroundColor(.offWhite)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
            HStack(alignment: .center, spacing: 35.0 * CGFloat(sizeMultiplier())) {

                // MARK: Home Button
                HomeButton(selectedTab: $selectedTab)

                // MARK: Search Button
                SearchButton(selectedTab: $selectedTab)

                // MARK: List Button
                MyListButton(selectedTab: $selectedTab)

                // MARK: Share Button
                ShareButton()

                // MARK: Parameter Button
                ParameterButton(selectedTab: $selectedTab)
            }
        }
    }

    struct HomeButton: View {
        @Binding var selectedTab: Int

        let iconFont = Font.system(size: 27).bold()
        let textFont = Font.system(size: 12)

        var body: some View {
            Button(action: {
                self.selectedTab = MenuItemEnum.home.rawValue
            }) {
                VStack(alignment: .center, spacing: 3) {
                    Image(systemName: "house")
                        .font(iconFont)
                        .foregroundColor(selectedTab == MenuItemEnum.home.rawValue ? Color.appBlue : Color.black)
                        .accessibilityLabel(Text("Home"))
                    Text("Home").font(textFont)
                        .foregroundColor(selectedTab == MenuItemEnum.home.rawValue ? Color.appBlue : Color.black)
                }
            }
        }
    }

    struct SearchButton: View {
        @Binding var selectedTab: Int

        let iconFont = Font.system(size: 27).bold()
        let textFont = Font.system(size: 12)

        var body: some View {
            Button(action: {
                self.selectedTab = MenuItemEnum.search.rawValue
            }) {
                VStack(alignment: .center, spacing: 3) {
                    Image(systemName: "magnifyingglass")
                        .font(iconFont)
                        .foregroundColor(selectedTab == MenuItemEnum.search.rawValue ? Color.appBlue : Color.black)
                        .accessibilityLabel(Text("Search"))
                    Text("Search").font(textFont)
                        .foregroundColor(selectedTab == MenuItemEnum.search.rawValue ? Color.appBlue : Color.black)
                }
            }
        }
    }

    struct MyListButton: View {

        @Binding var selectedTab: Int

        let iconFont = Font.system(size: 27).bold()
        let textFont = Font.system(size: 12)

        var body: some View {
            Button(action: {
                self.selectedTab = MenuItemEnum.myList.rawValue
            }, label: {
                VStack(alignment: .center, spacing: 3) {
                    Image(systemName: "bookmark")
                        .font(iconFont)
                        .foregroundColor(selectedTab == MenuItemEnum.myList.rawValue ? Color.appBlue : Color.black)
                        .accessibilityLabel(Text("My list"))
                    Text("My List").font(textFont)
                        .foregroundColor(selectedTab == MenuItemEnum.myList.rawValue ? Color.appBlue : Color.black)
                        .accessibilityLabel(Text("My list"))

                }
            })
        }
    }

    struct ShareButton: View {

        @State private var showShareSheet: Bool = false
        @State var shareSheetItems: [Any] = []
        var excludedActivityTypes: [UIActivity.ActivityType]?

        let iconFont = Font.system(size: 27).bold()
        let textFont = Font.system(size: 12)

        var body: some View {
            Button(action: {
                self.showShareSheet.toggle()
                shareSheetItems.append("Hello")
            }, label: {
                VStack(alignment: .center, spacing: 3) {
                    Image(systemName: "square.and.arrow.up")
                        .font(iconFont)
                        .foregroundColor(self.showShareSheet ? Color.appBlue : Color.black)
                        .accessibilityLabel(Text("Share"))
                    Text("Share")
                        .font(textFont)
                        .foregroundColor(
                            self.showShareSheet ? Color.appBlue : Color.black)
                }
            }).sheet(isPresented: $showShareSheet, content: {
                ActivityViewController(activityItems: self.$shareSheetItems, excludedActivityTypes: excludedActivityTypes)
            })
        }
    }

    struct ParameterButton: View {

        @Binding var selectedTab: Int

        let iconFont = Font.system(size: 27).bold()
        let textFont = Font.system(size: 12)

        var body: some View {
            Button(action: {
                self.selectedTab = MenuItemEnum.params.rawValue
            }, label: {
                VStack(alignment: .center, spacing: 3) {
                    Image(systemName: "gearshape")
                        .font(iconFont)
                        .foregroundColor(selectedTab == MenuItemEnum.params.rawValue ? Color.appBlue : Color.black)
                        .accessibilityLabel(Text("Params"))
                    Text("Params")
                        .font(textFont)
                        .foregroundColor(
                            selectedTab == MenuItemEnum.params.rawValue ? Color.appBlue : Color.black)
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

struct ActivityViewController: UIViewControllerRepresentable {
    @Binding var activityItems: [Any]
    var excludedActivityTypes: [UIActivity.ActivityType]?

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems,
                                                  applicationActivities: nil)

        controller.excludedActivityTypes = excludedActivityTypes

        return controller
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(selectedTab: .constant(0))
            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
            .previewDisplayName("iPhone 12")

        MenuView(selectedTab: .constant(0))
            .previewDevice(PreviewDevice(rawValue: "iPad 12"))
            .previewDisplayName("iPad 12")
    }
}
