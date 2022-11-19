import UIKit

class OAuth2Service {
    private enum NetworkError: Error {
        case codeError
    }
    private func fetchAuthToken(code: String, handler: @escaping () -> Swift.Result<String, Error>) {
        var request = URLRequest(url: OAUTH_STRING)

        request.httpMethod = "POST"

        let parameters: [String: Any] = [
            "client_id": ACCESS_KEY,
            "redirect_uri": REDIRECT_URI,
            "response_type": code,
            "scope": ACCESS_SCOPE
        ]

        do {
           // convert parameters to Data and assign dictionary to httpBody of request
           request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
         } catch let error {
           print(error.localizedDescription)
           return
         }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Проверяем, пришла ли ошибка
            if let error = error {
                handler(.failure(error))
                return
            }

            // Проверяем, что нам пришёл успешный код ответа
            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 && response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }

            // Возвращаем данные
            guard let data = data else { return }

            let apiResponse = try JSONDecoder().decode(UnsplashResponse.self, from: data)

            if apiResponse.isEmpty {
                DispatchQueue.main.async {
                    print("ERROR =", apiResponse.error)
                    handler(.failure(ApiError.genericError(message: apiResponse.error)))
                }
            } else {
                handler(.success(apiResponse))
                return
            }

        }
        task.resume()
}
}
