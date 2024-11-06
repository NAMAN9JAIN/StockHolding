//
//  NetworkLayer.swift
//  StockHolding
//
//  Created by Naman Jain on 01/11/24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
}

protocol Target {
    var baseUrl: String { get }
    var endpoint: String { get }
    var method: HTTPMethod { get }
}

enum APIRequestError: String, Error {
    case requestNotBuild = "Could not build request"
}

typealias ResponseModel = (data: Data?, response: URLResponse?, error: Error?)

protocol NetworkManager {
    func makeRequest(with target: Target, completion: @escaping ((ResponseModel) -> Void))
}

final class DefaultNetworkManager: NetworkManager {
    let session: URLSession
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func makeRequest(with target: Target, completion: @escaping ((ResponseModel) -> Void)) {
        do {
            let request = try RequestBuilder.buildRequest(withTarget: target)
            let task = session.dataTask(with: request, completionHandler: { data, response, error in
                DispatchQueue.main.async {
                    completion(ResponseModel(data, response, error))
                }
            })
            task.resume()
        } catch {
            DispatchQueue.main.async {
                completion(ResponseModel(nil, nil, nil))
            }
        }
    }
}

enum RequestBuilder {
    static func buildRequest(withTarget target: Target) throws -> URLRequest {
        let urlString = "\(target.baseUrl)\(target.endpoint)"
        guard let url = URL(string: urlString) else { throw APIRequestError.requestNotBuild }
        var request = URLRequest(url: url)
        request.httpMethod = target.method.rawValue
        return request
    }
}


