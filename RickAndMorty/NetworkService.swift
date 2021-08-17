import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    let baseURL = "https://rickandmortyapi.com/api"
    let jsonDecoder = JSONDecoder()
    
    private init() {}
    
    func fetchData<Request: APIRequest>(_ request: Request, url: String, completion: @escaping (Result<Request.Response, Error>) -> Void) {
        
        let urlComponents = URLComponents(string: url)!
        
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
