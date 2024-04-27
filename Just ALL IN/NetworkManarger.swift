//
//  NetworkManarger.swift
//  Just ALL IN
//
//  Created by 蕭煜勳 on 2024/4/17.
//

import UIKit

class NetworkManarger {
    
    static let shared  = NetworkManarger()
    let basedURL = "https://public.coindcx.com/market_data/candles/?pair=B-BTC_USDT&interval=1m"
    let singleURL = "https://public.coindcx.com/market_data/candles/?pair=B-BTC_USDT&interval=1m&limit=1"

    private init() {}
    
    func getCandlesData(completed: @escaping (Result<[Candels], CError>) -> Void) {
        guard let url = URL(string: basedURL) else {
            completed(.failure(CError.invailedURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(CError.invailedToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200  else {
                completed(.failure(CError.invailedResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(CError.emptyData))
                return
            }
            
            do {
                print("網路管理員\(data)")
                let decoder = JSONDecoder()
                let candlesData = try decoder.decode([Candels].self, from: data)
                completed(.success(candlesData))
            } catch {
                completed(.failure(CError.invailedDecode))
            }
        }
        task.resume()
    }
    
    
    func getSingleCandlesData(completed: @escaping (Result<Candels, CError>) -> Void) {
        guard let url = URL(string: singleURL) else {
            completed(.failure(CError.invailedURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(.failure(CError.invailedToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200  else {
                completed(.failure(CError.invailedResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(CError.emptyData))
                return
            }
            
            do {
                
                let decoder = JSONDecoder()
                let candlesData = try decoder.decode([Candels].self, from: data)
                guard let singleData = candlesData.first else {
                    print("singleData為空值")
                    return
                }
                completed(.success(singleData))
            } catch {
                completed(.failure(CError.invailedDecode))
            }
        }
        task.resume()
    }
    
}
