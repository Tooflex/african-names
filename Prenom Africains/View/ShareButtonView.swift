//
//  ShareButtonView.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 13/11/2021.
//

import SwiftUI
import L10n_swift

struct ShareButton: View {

    @Binding var firstname: FirstnameDB
    @State private var showShareSheet: Bool = false
    @State var shareSheetItems: [Any] = []
    var excludedActivityTypes: [UIActivity.ActivityType]?

    let iconFont = Font.system(size: 27).bold()
    let textFont = Font.system(size: 12)

    var body: some View {
        Button(action: {
            self.showShareSheet.toggle()
            shareSheetItems = []
            shareSheetItems.append(buildShareContent(firstname: self.firstname))
        }, label: {
            VStack(alignment: .center, spacing: 3) {
                Image(systemName: "square.and.arrow.up")
                    .font(iconFont)
                    .foregroundColor(Color.white)
                    .accessibilityLabel(Text("Share".l10n()))
                Text("Share".l10n())
                    .font(textFont)
                    .foregroundColor(Color.white)
            }
        }).sheet(isPresented: $showShareSheet, content: {
            ActivityViewController(
                activityItems: self.$shareSheetItems,
                excludedActivityTypes: excludedActivityTypes
            )
        })
    }

    func buildShareContent(firstname: FirstnameDB) -> String {
        return """
"The name \(firstname.firstname) means \(firstname.meaning.prefix(30))"
"Discover more on this link"
"""
    }

    }

struct ActivityViewController: UIViewControllerRepresentable {
    @Binding var activityItems: [Any]
    var excludedActivityTypes: [UIActivity.ActivityType]?

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
            let controller = UIActivityViewController(activityItems: activityItems,
                                                      applicationActivities: nil)

            controller.excludedActivityTypes = excludedActivityTypes

            return controller
        }
    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: UIViewControllerRepresentableContext<ActivityViewController>) {}
}
