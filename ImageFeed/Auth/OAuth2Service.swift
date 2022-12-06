import UIKit

class OAuth2Service {
    
    private enum NetworkError: Error {
        case codeError
    }
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private func makeRequest(code: String) -> URLRequest {
        var urlComponents = URLComponents(string: Constants.oauthString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectUri),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        let url = urlComponents.url!
        //          guard let url = URL(string: "...\(code)") else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    func fetchAuthToken(
        code: String,
        handler: @escaping (Result<String, Error>) -> Void) {
            
            assert(Thread.isMainThread)
            if lastCode == code { return }                      // 1
            task?.cancel()                                      // 2
            lastCode = code
            let request = makeRequest(code: code)
            
            //            var urlComponents = URLComponents(string: Constants.oauthString)!
            //            urlComponents.queryItems = [
            //                URLQueryItem(name: "client_id", value: Constants.accessKey),
            //                URLQueryItem(name: "client_secret", value: Constants.secretKey),
            //                URLQueryItem(name: "redirect_uri", value: Constants.redirectUri),
            //                URLQueryItem(name: "code", value: code),
            //                URLQueryItem(name: "grant_type", value: "authorization_code")
            //            ]
            //            let url = urlComponents.url!
            
            //            var request = URLRequest(url: url)
            //            request.httpMethod = "POST"
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let error = error {
                    handler(.failure(error))
                    return
                }
                
                if let response = response as? HTTPURLResponse,
                   response.statusCode < 200 && response.statusCode >= 300 {
                    DispatchQueue.main.async {
                        handler(.failure(NetworkError.codeError))
                        //                        if error != nil {
                        //                            self.lastCode = nil
                        //                        }
                    }
                }
                
                guard let data = data else { return }
                let apiResponse = try? JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                guard let apiResponse = apiResponse else {
                    DispatchQueue.main.async {
                        handler(.failure(NetworkError.codeError))
                    }
                    return
                }
                DispatchQueue.main.async {
                    handler(.success(apiResponse.accessToken))
                    self.task = nil
                    if error != nil {
                        self.lastCode = nil
                    }
                }
            }
            self.task = task
            task.resume()
        }
    
}
