//
//  Usecase.swift
//  StockHolding
//
//  Created by Naman Jain on 01/11/24.
//

import Foundation

protocol Usecase {
    func fetchHoldingsData(completion: @escaping ((Result<Holdings, HoldingsErrorReasons>) -> Void))
}

enum HoldingsErrorReasons: Error {
    case holdingsNotFetched
    case noHoldingsPresent
}

final class DefaultUsecase: Usecase {
    let networkManager: any NetworkManager
    init(networkManager: any NetworkManager = DefaultNetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchHoldingsData(completion: @escaping ((Result<Holdings, HoldingsErrorReasons>) -> Void)) {
        networkManager.makeRequest(with: DefaultTarget.holding) { responseModel in
            guard let data = responseModel.data else {
                completion(.failure(.holdingsNotFetched))
                return
            }
            do {
                let model = try JSONDecoder().decode(Holdings.self, from: data)
                completion(.success(model))
            } catch {
                completion(.failure(.holdingsNotFetched))
            }
        }
    }
}
