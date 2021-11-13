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
}

final class FirstNameApiService: FirstNameApiServiceProtocol {

    private let manager: Session
    init(manager: Session = Session.default) {
        self.manager = manager
        manager.sessionConfiguration.timeoutIntervalForRequest = 30
        manager.sessionConfiguration.timeoutIntervalForResource = 30
    }

    private let apiEndpoint = Bundle.main.infoDictionary!["API_ENDPOINT"] as? String

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

}
