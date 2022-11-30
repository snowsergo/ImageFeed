import UIKit

class OAuth2Service {
    
    private enum NetworkError: Error {
        case codeError
    }
    func fetchAuthToken(
        code: String,
        handler: @escaping (Result<String, Error>) -> Void) {
            var urlComponents = URLComponents(string: Constants.oauthString)!
            urlComponents.queryItems = [
                URLQueryItem(name: "client_id", value: Constants.accessKey),
                URLQueryItem(name: "client_secret", value: Constants.secretKey),
                URLQueryItem(name: "redirect_uri", value: Constants.redirectUri),
                URLQueryItem(name: "code", value: code),
                URLQueryItem(name: "grant_type", value: "authorization_code")
            ]
            let url = urlComponents.url!
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let error = error {
                    handler(.failure(error))
                    return
                }
                
                if let response = response as? HTTPURLResponse,
                   response.statusCode < 200 && response.statusCode >= 300 {
                    DispatchQueue.main.async {
                        handler(.failure(NetworkError.codeError))
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
                }
            }
            task.resume()
        }
}
