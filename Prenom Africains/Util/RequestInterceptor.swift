//
//  RequestInterceptor.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 17/09/2022.
//

 import Foundation
 import Alamofire

protocol AccessTokenStorage: AnyObject {
	typealias JWT = String
	var accessToken: JWT { get set }
 }

 final class RequestInterceptor: Alamofire.RequestInterceptor {

	let retryLimit = 3
	let retryDelay: TimeInterval = 2
	var isRetrying = false

	private let storage: AccessTokenStorage
	 let loginApiService = AuthentificationService()

	init(storage: AccessTokenStorage) {
		self.storage = storage
	}

	func adapt(
		_ urlRequest: URLRequest,
		for session: Session,
		completion: @escaping (Result<URLRequest, Error>) -> Void) {
			// swiftlint:disable force_try
			let prefix = try! "https://" + Configuration.value(for: "API_ENDPOINT")
		guard urlRequest.url?.absoluteString.hasPrefix(prefix) == true else {
			return completion(.success(urlRequest))
		}
		var urlRequest = urlRequest

		urlRequest.setValue("Bearer " + storage.accessToken, forHTTPHeaderField: "Authorization")

		completion(.success(urlRequest))
	}

	func retry(
		_ request: Request,
		for session: Session,
		dueTo error: Error,
		completion: @escaping (RetryResult) -> Void) {
			guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401, !isRetrying else {
			return completion(.doNotRetryWithError(error))
		}
			print("Call login api")
			self.isRetrying = true
			if request.retryCount < self.retryLimit {
				loginApiService.login { result in
					guard let token = result.value?.jwt else {
						completion(.doNotRetryWithError(error))
						return
					}
					self.storage.accessToken = token
					completion(.retryWithDelay(self.retryDelay))
				}
			} else {
				completion(.doNotRetry)
			}
	}
 }
