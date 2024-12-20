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
    
    let firstnameRepository: FirstNameRepository
    
    let fistnameService: FirstNameService
    let filterService: FilterService
    
	var contentViewModel: ContentViewModel
	var firstnameViewModel: FirstNameViewModel
	var searchViewModel: SearchScreenViewModel
	var paramViewModel: ParamViewModel
    var searchScreenViewModel: SearchScreenViewModel
    var favoriteListViewModel: FavoriteListViewModel
	let adsViewModel = AdsViewModel.shared

	init() {
		FirebaseApp.configure()
		RemoteConfigManager.configure()
		GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        firstnameRepository = FirstNameRepository()
        fistnameService = FirstNameService(repository: firstnameRepository)
        filterService = FilterService()
        contentViewModel = ContentViewModel(service: fistnameService, filterService: filterService)
        firstnameViewModel = FirstNameViewModel(service: fistnameService)
        paramViewModel = ParamViewModel()
        searchViewModel = SearchScreenViewModel(service: fistnameService, filterService: filterService)
        searchScreenViewModel = SearchScreenViewModel(service: fistnameService, filterService: filterService)
        favoriteListViewModel = FavoriteListViewModel(service: fistnameService)
        
		LottieConfiguration.shared.renderingEngine = .mainThread

	}
    
    func getEncryptionKey() -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.tooflexdev.Prenom-Africains.realm.encryptionKey",
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject? = nil
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            return dataTypeRef as? Data
        } else {
            print("Error retrieving key from Keychain: \(status)")
            return nil
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(firstnameViewModel)
                .environmentObject(searchScreenViewModel)
                .environmentObject(paramViewModel)
                .environmentObject(contentViewModel)
                .environmentObject(adsViewModel)
                .environmentObject(favoriteListViewModel)
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
//                 .onAppear {
//                     if let key = getEncryptionKey() {
//                         print("eee")
//                         print(key)
//                     }
//                 }
        }
    }
}
