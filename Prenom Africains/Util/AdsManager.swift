//
//  AdsManager.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 05/11/2022.
//

import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport

class AdsManager: NSObject, ObservableObject {

	private struct AdMobConstant {
		#if DEBUG
		static let interstitial1ID = "ca-app-pub-3940256099942544/4411468910"
		#else
		static let interstitial1ID = "ca-app-pub-9839591490433108/1234250181"
		#endif
	}

	final class Interstitial: NSObject, GADFullScreenContentDelegate, ObservableObject {

		private var interstitial: GADInterstitialAd?

		override init() {
			super.init()
			requestInterstitialAds()
		}

		func requestInterstitialAds() {
			let request = GADRequest()
			request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
			ATTrackingManager.requestTrackingAuthorization(completionHandler: { _ in
				GADInterstitialAd.load(withAdUnitID: AdMobConstant.interstitial1ID, request: request, completionHandler: { [self] ad, error in
					if let error = error {
						print("Failed to load interstitial ad with error: \(error.localizedDescription)")
						return
					}
					interstitial = ad
					interstitial?.fullScreenContentDelegate = self
				})
			})
		}
		func showAd() {
			let root = UIApplication.shared.windows.last?.rootViewController
			if let fullScreenAds = interstitial {
				fullScreenAds.present(fromRootViewController: root!)
			} else {
				print("not ready")
			}
		}

	}

}

class AdsViewModel: ObservableObject {
	static let shared = AdsViewModel()
	@Published var interstitial = AdsManager.Interstitial()
	@Published var showInterstitial = false {
		didSet {
			if showInterstitial {
				interstitial.showAd()
				showInterstitial = false
			} else {
				interstitial.requestInterstitialAds()
			}
		}
	}
}
