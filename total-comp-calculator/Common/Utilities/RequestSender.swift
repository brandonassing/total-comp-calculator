//
//  Networking.swift
//  total-comp-calculator
//
//  Created by Brandon Assing on 2024-11-14.
//

import Foundation

struct RequestSender {
    let apiKey: String?
    let baseURL: String
    
    func getURL(with queryParams: [String: String], apiKey: String) -> URL? {
        let queryParams = queryParams.merging(["apikey": apiKey]) { current, new in new }
        
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }

        return urlComponents?.url
    }
    
    func makeRequest(with queryParams: [String: String]) async -> Result<Data, Error> {
        guard let apiKey = apiKey else {
            return .failure(NetworkError.invalidAPIKey)
        }
        guard let url = getURL(with: queryParams, apiKey: apiKey) else {
            return .failure(NetworkError.invalidURL)
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(NetworkError.noResponse)
            }
            guard httpResponse.statusCode == 200 else {
                return .failure(NetworkError.badResponse(httpResponse.statusCode))
            }

            #if DEBUG
            if let responseString = String(data: data, encoding: .utf8) {
                print(responseString)
            }
            #endif
            
            return .success(data)
        } catch {
            return .failure(NetworkError.unknown(error))
        }
    }
}

extension RequestSender {
    enum NetworkError: Error {
        case invalidAPIKey
        case invalidURL
        case noResponse
        case badResponse(_ statusCode: Int)
        case decodingFailed
        case unknown(Error)
    }
}
