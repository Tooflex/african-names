//
//  Prenom_AfricainsApp.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 22/03/2021.
//

import SwiftUI
import RealmSwift
import FirebaseCore
import FirebaseDynamicLinks
import GoogleMobileAds
import Lottie

@main
struct PrenomAfricainsApp: App {

	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

	var contentViewModel: ContentViewModel
	var firstnameViewModel: FirstNameViewModel
	var searchViewModel: SearchScreenViewModel
	var paramViewModel: ParamViewModel
	let adsViewModel = AdsViewModel.shared

	init() {
		FirebaseApp.configure()
		RemoteConfigManager.configure()
		GADMobileAds.sharedInstance().start(completionHandler: nil)
		firstnameViewModel = FirstNameViewModel()
		searchViewModel = SearchScreenViewModel()
		paramViewModel = ParamViewModel()
		contentViewModel = ContentViewModel()
		LottieConfiguration.shared.renderingEngine = .mainThread

	}

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(firstnameViewModel)
                 .environmentObject(searchViewModel)
                 .environmentObject(paramViewModel)
				 .environmentObject(contentViewModel)
				 .environmentObject(adsViewModel)
			// 1
				 .onOpenURL { url in
					 print("Incoming URL parameter is: \(url)")
					 // 2
					 let linkHandled = DynamicLinks.dynamicLinks()
						 .handleUniversalLink(url) { dynamicLink, error in
							 guard error == nil else {
								 print("Error handling the incoming dynamic link.")
								 return
							 }
							 // 3
							 if let dynamicLink = dynamicLink {
								 // Handle Dynamic Link
								 guard let url = dynamicLink.url else { return }

								 print("Your incoming link parameter is \(url.absoluteString)")
								 // 1
								 guard
									dynamicLink.matchType == .unique ||
										dynamicLink.matchType == .default
								 else {
									 return
								 }

								 if contentViewModel.checkDeepLink(url: url) {
									 						 print("FROM DEEP LINK")
									 					 } else {
									 						 print("FALL BACK DEEP LINK")
									 					 }
							 }
						 }
					 // 4
					 if linkHandled {
						 print("Link Handled")
					 } else {
						 print("No Link Handled")
					 }
				 }
        }
    }
}
