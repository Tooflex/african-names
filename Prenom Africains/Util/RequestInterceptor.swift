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

	private let storage: AccessTokenStorage
	 let loginApiService = AuthentificationService()

	init(storage: AccessTokenStorage) {
		self.storage = storage
	}

	func adapt(
		_ urlRequest: URLRequest,
		for session: Session,
		completion: @escaping (Result<URLRequest, Error>) -> Void) {
		guard urlRequest.url?.absoluteString.hasPrefix("https://africannames.app") == true else {
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
			guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
			return completion(.doNotRetryWithError(error))
		}
			print("Call login api")
			loginApiService.login { result in
				guard let token = result.value?.jwt else {
					completion(.doNotRetryWithError(error))
					return
				}
				self.storage.accessToken = token
				completion(.retry)
			}
	}
 }
