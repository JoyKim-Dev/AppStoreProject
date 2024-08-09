//
//  NetworkManager.swift
//  AppStoreProject
//
//  Created by Joy Kim on 8/8/24.
//

// MARK: - Todo: tableView 선택 효과 없애기, network 통신 pagination, 최근검색어 저장, Realm...

import Foundation
import RxSwift

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
    case decodingError
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func callAppSearch(query: String) -> Observable<Application> {
        let urlString = "https://itunes.apple.com/search?term=\(query)&country=KR&media=software"
        
        let result = Observable<Application>.create { observer in
            guard let url = URL(string: urlString) else {
                print(urlString)
                observer.onError(APIError.invalidURL)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Network Error: \(error.localizedDescription)")
                    observer.onError(APIError.unknownResponse)
                    return
                }
                guard let response = response as? HTTPURLResponse,
                    (200...299).contains(response.statusCode) else {
                    observer.onError(APIError.statusError)
                    return
                }
                
                
                if let data = data {
                                
                                   if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                                       print("JSON Response: \(json)")
                                   }
                                   
                                 
                                   if let appData = try? JSONDecoder().decode(Application.self, from: data) {
                                       observer.onNext(appData)
                                       observer.onCompleted()
                                   } else {
                                       observer.onError(APIError.unknownResponse)
                                   }
                               } else {
                                   observer.onError(APIError.unknownResponse)
                               }
                           }.resume()
                           return Disposables.create()
                       }
                       return result
                   }
               }
