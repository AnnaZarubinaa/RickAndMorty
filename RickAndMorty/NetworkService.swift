import Foundation
import UIKit

class NetworkService {
    
    static let shared = NetworkService()
    let baseURL = "https://rickandmortyapi.com/api"
    let jsonDecoder = JSONDecoder()
    
    private init() {}
    
    func fetchData<Request: APIRequest>(_ request: Request, url: String, completion: @escaping (Result<Request.Response, Error>) -> Void) {
        
        if let urlComponents = URLComponents(string: url) {
            let task = URLSession.shared.dataTask(with: urlComponents.url!) { (data, response, error) in
                    if let data = data {
                        do {
                            let decodedResponse = try
                               request.decodeResponse(data: data)
                            completion(.success(decodedResponse))
                        } catch {
                            completion(.failure(error))
                        }
                    } else if let error = error {
                        completion(.failure(error))
                    }
                }
            task.resume()
        }
    }
    
    func fetchImage(from url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let urlComponents = URLComponents(string: url)!
        
        let task = URLSession.shared.dataTask(with: urlComponents.url!) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
            } else if let data = data, let image = UIImage(data: data) {
                completion(.success(image))
            }
        }
        
        task.resume()
    }
}
