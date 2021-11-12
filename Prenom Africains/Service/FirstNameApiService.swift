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
    func fetchFirstnames(completion: @escaping ([FirstnameDataModel]) -> Void)
}

final class FirstNameApiService: FirstNameApiServiceProtocol {

    private let manager: Session
    init(manager: Session = Session.default) {
        self.manager = manager
    }

    private let apiEndpoint = Bundle.main.infoDictionary!["API_ENDPOINT"] as? String

    let username = "user"
    let password = "Manjack76"

    var tokens: Set<AnyCancellable> = []

    func fetchFirstnames(completion: @escaping ([FirstnameDataModel]) -> Void) {
        guard let url = URL(string: "\(apiEndpoint ?? "")/api/v1/firstnames/random" ) else {
            print("Error: cannot create URL")
            return
        }

        let headers: HTTPHeaders = [.authorization(username: username, password: password)]

        manager.request(url, headers: headers) { $0.timeoutInterval = 5 }
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
                switch response.result {
                case .success(let model):
                        completion(model)
                case .failure(let error):
                        print(error)
                }
            }).store(in: &tokens)
    }

    func fetchFirstnamesMock(completion: @escaping ([FirstnameDataModel]) -> Void) {

    }
}
