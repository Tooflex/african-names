//
//  FirstNameApiService.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 24/10/2021.
//

import Foundation
import Alamofire
import Combine
import L10n_swift

protocol FirstNameApiServiceProtocol {

    func fetchFirstnames(completion: @escaping (DataResponse<FirstnameResponse, AFError>) -> Void)

	func fetchFirstnames(numberOfElements: Int, completion: @escaping (DataResponse<FirstnameResponse, AFError>) -> Void)

    func searchFirstnamesRemote(
        searchString: String,
        completion: @escaping (DataResponse<[FirstnameDataModel], AFError>) -> Void)

    func filterFirstnamesRemote(
        filterChain: String,
        completion: @escaping (DataResponse<[FirstnameDataModel], AFError>) -> Void)

    func fetchOrigins(completion: @escaping (DataResponse<[String], AFError>) -> Void)
}

final class FirstNameApiService: FirstNameApiServiceProtocol {

	private let manager: Session
	init(manager: Session = Session(interceptor: RequestInterceptor(storage: AuthToken()))) {
        self.manager = manager
        manager.sessionConfiguration.timeoutIntervalForRequest = 30
        manager.sessionConfiguration.timeoutIntervalForResource = 30
    }

    private let apiEndpoint = API.baseURL

    private let searchEndpoint = "/api/v1/firstnames/search/?search="
    private let originsEndpoint = "/api/v1/origins"
    private let orUrlSeparator = "*%20OR%20"

    var tokens: Set<AnyCancellable> = []

    func fetchFirstnames(completion: @escaping (DataResponse<FirstnameResponse, AFError>) -> Void) {
		let languageCodeSelection = L10n.shared.language
		let parameters: Parameters = [
			"lang": languageCodeSelection
		]
        guard let url = URL(string: "api/v1/firstnames", relativeTo: API.baseURL) else {
            print("Error: cannot create URL")
            return
        }

        manager.request(url, parameters: parameters)
            .validate()
            .publishDecodable(type: FirstnameResponse.self)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .finished:
                        ()
                case .failure(let error):
                        print(error)
                }
            }, receiveValue: { (response) in
                completion(response)
            }).store(in: &tokens)
    }

	func fetchFirstnames(numberOfElements: Int, completion: @escaping (DataResponse<FirstnameResponse, AFError>) -> Void) {

		if numberOfElements > 0 {
			let languageCodeSelection = L10n.shared.language
			let parameters: Parameters = [
				"lang": languageCodeSelection,
				"size": numberOfElements,
				"page": 0
			]
			guard let url = URL(string: "api/v1/firstnames", relativeTo: API.baseURL) else {
				print("Error: cannot create URL")
				return
			}

			manager.request(url, parameters: parameters)
				.validate()
				.publishDecodable(type: FirstnameResponse.self)
				.sink(receiveCompletion: { (completion) in
					switch completion {
						case .finished:
							()
						case .failure(let error):
							print(error)
					}
				}, receiveValue: { (response) in
					completion(response)
				}).store(in: &tokens)
		}
	}

    func searchFirstnamesRemote(
        searchString: String,
        completion: @escaping (DataResponse<[FirstnameDataModel], AFError>) -> Void) {
        print("Calling searchFirstnames")

        if !searchString.isEmpty {
            guard let url = URL(
                string: "\(searchEndpoint)firstname:\(searchString)\(orUrlSeparator)origins:\(searchString)*",
                relativeTo: API.baseURL)
            else {
                print("Error: cannot create URL")
                return
            }

                print(url)

                AF.request(url)
                    .validate()
                    .publishDecodable(type: [FirstnameDataModel].self)
                    .sink(receiveCompletion: { (completion) in
                        switch completion {
                        case .finished:
                            ()
                        case .failure(let error):
                            print(error)
                        }
                    }, receiveValue: { (response) in
                        completion(response)
                    }).store(in: &tokens)

        }
    }

    func filterFirstnamesRemote(
        filterChain: String,
        completion: @escaping (DataResponse<[FirstnameDataModel], AFError>) -> Void) {
        print("Calling filterFirstnames")

            guard let url = URL(
                string:
            """
            \(apiEndpoint)\(searchEndpoint)\(filterChain)
            """,
                relativeTo: API.baseURL)
            else {
                print("Error: cannot create URL")
                return
            }

            print("URL called: \(url)")

            AF.request(url)
                .validate()
                .publishDecodable(type: [FirstnameDataModel].self)
                .sink(receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        ()
                    case .failure(let error):
                        print(error)
                    }
                }, receiveValue: { (response) in
                    completion(response)
                }).store(in: &tokens)

    }

    func fetchOrigins(completion: @escaping (DataResponse<[String], AFError>) -> Void) {
        print("Calling get origins")

        guard let url = URL(string: originsEndpoint, relativeTo: API.baseURL) else {
            print("Error: cannot create URL")
            return
        }

            AF.request(url)
                .validate()
                .publishDecodable(type: [String].self)
                .sink(receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        ()
                    case .failure(let error):
                        print(error)
                    }
                }, receiveValue: { (response) in
                    completion(response)
                }).store(in: &tokens)
        }

}
