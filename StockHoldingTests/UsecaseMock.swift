//
//  UsecaseMock.swift
//  StockHoldingTests
//
//  Created by Naman Jain on 06/11/24.
//

@testable import StockHolding
import Foundation

final class UsecaseMock: Usecase  {
    enum MockResponseType {
        case success(holdingPresent: Bool)
        case apiFailed
    }
    var response: MockResponseType = .success(holdingPresent: true)
    
    func fetchHoldingsData(completion: @escaping ((Result<StockHolding.Holdings, StockHolding.HoldingsErrorReasons>) -> Void)) {
        switch response {
        case .success(let holdingPresent):
            let data = holdingPresent ? getSuccessWithHoldingsResponse() : getSuccessWithNoHoldingsResponse()
            if let data {
                completion(.success(data))
            } else {
                completion(.failure(.holdingsNotFetched))
            }
        case .apiFailed:
            completion(.failure(.holdingsNotFetched))
        }
    }

    private func getSuccessWithHoldingsResponse() -> StockHolding.Holdings? {
        return try? JSONDecoder().decode(Holdings.self, from: Data(mockSuccessWithHoldingsResponse))
    }
    
    private func getSuccessWithNoHoldingsResponse() -> StockHolding.Holdings? {
        return try? JSONDecoder().decode(Holdings.self, from: Data(mockSuccessWithNoHoldingsResponse))
    }
}
