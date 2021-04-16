//
//  FirstNameViewModel.swift
//  Prenom Africains
//
//  Created by Otourou Da Costa on 22/03/2021.
//

import Foundation
import Alamofire
import Combine

class FirstNameViewModel: ObservableObject {
    @Published var firstnames = [PrenomAF]()
    @Published var loaded = false
    
    var tokens: Set<AnyCancellable> = []
    
    private let url = "https://e76d5d817461.ngrok.io/api/firstnames/random"
    private var task: AnyCancellable?
    
    init() {
        fetchFirstnames()
    }
    
    func fetchFirstnames() {
        
        loaded = true
        
        let username = "user"
        let password = "Manjack76"
        
        let headers: HTTPHeaders = [.authorization(username: username, password: password)]
        
        AF.request(url, headers: headers)
            .validate()
            .publishDecodable(type: [PrenomAF].self)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .finished:
                    ()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }, receiveValue: { (response) in
                switch response.result {
                case .success(let model):
                    self.firstnames = model
                    self.loaded = false

                case .failure(let error):
                    print(error.localizedDescription)
                }
            }).store(in: &tokens)
    }
    
    
}


//var samplefirstnames: [PrenomAF] = load("MOCK_DATA.json")
//
//func load<T: Decodable>(_ filename: String) -> T {
//    let data: Data
//        
//    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
//    else {
//        fatalError("Couldn't find \(filename) in main bundle.")
//    }
//    
//    do {
//        data = try Data(contentsOf: file)
//    } catch {
//        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
//    }
//    
//    do {
//        let decoder = JSONDecoder()
//        return try decoder.decode(T.self, from: data)
//    } catch {
//        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
//    }
//}
//
//
