//
//  RemoteConfigManager.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 05/11/2022.
//

import Firebase

struct RemoteConfigManager {

	private static var remoteConfig: RemoteConfig = {
		var remoteConfig = RemoteConfig.remoteConfig()

		let settings = RemoteConfigSettings()
		settings.minimumFetchInterval = 0 // TODO: 7200
		remoteConfig.configSettings = settings
		remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
		return remoteConfig
	}()

	static func configure(expirationDuration: TimeInterval = 7200.0) {
		remoteConfig.fetch(withExpirationDuration: expirationDuration) { _, error in

			if let error = error {
				print(error.localizedDescription)
				return
			}
			print("New values from Remote Config loaded")
			RemoteConfig.remoteConfig().activate(completion: nil)
		}
	}

	static func value(forKey key: String) -> String {
		return remoteConfig.configValue(forKey: key).stringValue!
	}

}
