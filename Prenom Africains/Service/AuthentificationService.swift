//
//  AuthentificationService.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 17/09/2022.
//

import Foundation
import Alamofire
import Combine

protocol AuthentificationServiceProtocol {

	func login(completion: @escaping(DataResponse<LoginResponse, AFError>) -> Void)
}

final class AuthentificationService: AuthentificationServiceProtocol {

	private let manager: Session
	init(manager: Session = Session.default) {
		self.manager = manager
		manager.sessionConfiguration.timeoutIntervalForRequest = 10
		manager.sessionConfiguration.timeoutIntervalForResource = 10
	}

	 private let username = Bundle.main.infoDictionary!["API_USER"] as? String ?? ""
	 private let password = ProcessInfo.processInfo.environment["API_PASSWORD"] ?? Bundle.main.infoDictionary!["API_PASSWORD"] as? String ?? ""

	var tokens: Set<AnyCancellable> = []

	func login(completion: @escaping (Alamofire.DataResponse<LoginResponse, Alamofire.AFError>) -> Void) {

		guard let url = URL(string: "api/v1/auth/login", relativeTo: API.baseURL) else {
			print("Error: cannot create URL")
			return
		}

		let payload = Payload(
			username: username,
			password: password)

		let headers: HTTPHeaders = [.authorization(username: username, password: password)]

		manager.request(url, method: .post, parameters: payload, encoder: JSONParameterEncoder.default, headers: headers)
			.validate()
			.publishDecodable(type: LoginResponse.self)
			.sink(receiveCompletion: { (completion) in
				switch completion {
					case .finished:
						()
						break
					case .failure(let error):
						print(error)
				}
			}, receiveValue: { (response) in
				completion(response)
			}).store(in: &tokens)

	}

}
