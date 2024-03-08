//
//  TMDb_UzmaApp.swift
//  TMDb-Uzma
//
//  Created by Uzma Sayyed on 06/03/24.
//

import Foundation
import NetworkingByUzma

public class NetworkManager {
    
    private let networkService: ServiceManager
    private let apiKey = "909594533c98883408adef5d56143539"
    
    public init() {
        networkService = ServiceManager.shared
    }
    
    func fetchPopularMov(page: Int, completionHandler: @escaping  (PopularMovResponseModel?) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=en-US&page=\(page)"
        
        networkService.callService(urlString: urlString, method: .get, success: { (response: PopularMovResponseModel) in
            completionHandler(response)
        }, fail: { error in
            completionHandler(nil)
        })
    }
    
    func fetchLatestMovie(completionHandler: @escaping ([MovieInfoModel]?) -> Void) {
            if let url = URL(string: "https://api.themoviedb.org/3/movie/latest?api_key=\(apiKey)&language=en-US") {
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if let err = error {
                        print("An Error Occurred: \(err.localizedDescription)")
                        completionHandler(nil)
                        return
                    }
                    guard let mime = response?.mimeType, mime == "application/json" else {
                        print("Wrong MIME type!")
                        completionHandler(nil)
                        return
                    }
                    if let jsonData = data {
                        do {
                            let decoder = JSONDecoder()
                            decoder.keyDecodingStrategy = .convertFromSnakeCase
                            // Decoding the single latest movie to MovieInfoModel
                            let decodedLatestMovie = try decoder.decode(MovieInfoModel.self, from: jsonData)
                            // Wrapping the single movie into an array
                            completionHandler([decodedLatestMovie])
                        } catch {
                            print("JSON error: \(error.localizedDescription)")
                            completionHandler(nil)
                        }
                    }
                }
                task.resume()
            } else {
                print("Invalid URL")
                completionHandler(nil)
            }
        }

}

