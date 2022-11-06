//
//  ShareButtonView.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 13/11/2021.
//

import SwiftUI
import L10n_swift
import FirebaseDynamicLinks
import Firebase

struct ShareButton: View {

	@Binding var firstname: FirstnameDB
	@State private var showShareSheet: Bool = false
	@State var shareSheetItems: [Any] = []
	var excludedActivityTypes: [UIActivity.ActivityType]?

	let iconFont = Font.system(size: 27).bold()
	let textFont = Font.system(size: 12)

	var body: some View {
		Button(action: {
			Analytics.logEvent(AnalyticsEventShare, parameters: [
				AnalyticsParameterItemID: firstname.id,
				AnalyticsParameterContentType: "url"
			])
			generateDynamicLink(firstname: self.firstname) { url in
				self.showShareSheet.toggle()
				shareSheetItems = []
				let contentToShare = buildShareContent(firstname: firstname, url: url)
				shareSheetItems.append(contentToShare[0])
				shareSheetItems.append(contentToShare[1])
			}

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

	func buildShareContent(firstname: FirstnameDB, url: URL) -> [AnyObject] {
		return ["""
"The name \(firstname.firstname) means \(firstname.meaning.prefix(30))"
"Discover more on this link"
""" as AnyObject, url as AnyObject]

	}

	func generateDynamicLink(firstname: FirstnameDB, completion: @escaping (URL) -> Void) {
		var components = URLComponents()
		components.scheme = "https"
		components.host = "africannames.app"
		components.path = "/"

		let firstnameQueryItem = URLQueryItem(name: "name", value: firstname.firstname)
		components.queryItems = [firstnameQueryItem]

		guard let linkParameter = components.url else { return }
		print("Generating \(linkParameter.absoluteString)")

		// Create the dynamic link
		guard let shareLink = DynamicLinkComponents.init(link: linkParameter, domainURIPrefix: "https://africannames.page.link") else {
			print("Couldn't create the FDL components")
			return
		}

		if let bundelID = Bundle.main.bundleIdentifier {
			shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: bundelID)
		}
		shareLink.iOSParameters?.appStoreID = "6443639146"
		shareLink.iOSParameters?.fallbackURL = URL(string: "https://africannames.app")
		shareLink.androidParameters = DynamicLinkAndroidParameters(packageName: "com.tooflexdev.Prenom-Africains")
		shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
		shareLink.socialMetaTagParameters?.title = "\(firstname.firstname) - African Names App"
		shareLink.socialMetaTagParameters?.descriptionText = "\(firstname.meaning)"

		guard let longURL = shareLink.url else { return }
		print("The long dynamic link is \(longURL)")

		shareLink.shorten { shortURL, _, error in
			if let error = error {
				print(error.localizedDescription)
				return
			}

			guard let shortLink = shortURL else { return }
			print(shortLink.absoluteString)
			completion(shortLink)
		}

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
