//
//  FirstNameApiService.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 24/10/2021.
//

import Foundation
import Alamofire
import Combine

protocol FirstNameApiServiceProtocol {

    func fetchFirstnames(completion: @escaping (DataResponse<[FirstnameDataModel], AFError>) -> Void)

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
    init(manager: Session = Session.default) {
        self.manager = manager
        manager.sessionConfiguration.timeoutIntervalForRequest = 30
        manager.sessionConfiguration.timeoutIntervalForResource = 30
    }

    private let apiEndpoint = Bundle.main.infoDictionary!["API_ENDPOINT"] as? String

    private let searchEndpoint = "/api/v1/firstnames/search/?search="
    private let originsEndpoint = "/api/v1/origins"
    private let orUrlSeparator = "*%20OR%20"

    let username = "user"
    let password = "Manjack76"

    var tokens: Set<AnyCancellable> = []

    func fetchFirstnames(completion: @escaping (DataResponse<[FirstnameDataModel], AFError>) -> Void) {
        guard let url = URL(string: "\(apiEndpoint ?? "")/api/v1/firstnames/random" ) else {
            print("Error: cannot create URL")
            return
        }

        let headers: HTTPHeaders = [.authorization(username: username, password: password)]

        manager.request(url, headers: headers)
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

    func searchFirstnamesRemote(
        searchString: String,
        completion: @escaping (DataResponse<[FirstnameDataModel], AFError>) -> Void) {
        print("Calling searchFirstnames")

        if !searchString.isEmpty {
            if let apiEndpoint = apiEndpoint {
                let url =
            """
            \(apiEndpoint)\(searchEndpoint)firstname:\(searchString)\(orUrlSeparator)origins:\(searchString)*
            """
                print(url)

                let headers: HTTPHeaders = [.authorization(username: username, password: password)]

                AF.request(url, headers: headers)
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
            } else {
                return
            }
        }
    }

    func filterFirstnamesRemote(
        filterChain: String,
        completion: @escaping (DataResponse<[FirstnameDataModel], AFError>) -> Void) {
        print("Calling filterFirstnames")

        if let apiEndpoint = apiEndpoint {

            let url =
            """
            \(apiEndpoint)\(searchEndpoint)\(filterChain)
            """

            print("URL called: \(url)")

            let headers: HTTPHeaders = [.authorization(username: username, password: password)]

            AF.request(url, headers: headers)
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

    func fetchOrigins(completion: @escaping (DataResponse<[String], AFError>) -> Void) {
        print("Calling get origins")

        if let apiEndpoint = apiEndpoint {

            let url = "\(apiEndpoint)\(originsEndpoint)"

            let headers: HTTPHeaders = [.authorization(username: username, password: password)]

            AF.request(url, headers: headers)
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

}
