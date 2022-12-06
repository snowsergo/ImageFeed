import UIKit

struct ProfileImage: Codable {
    let small: String?
    let medium: String?
    let large: String?
}

struct ProfileResult: Codable{
    let userName: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    let profileImage: ProfileImage?

    enum CodingKeys: String, CodingKey {
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
        case profileImage = "profile_image"
    }
}

struct Profile {
    let username: String
    let name: String
    let loginName : String
    let bio: String?

}

final class ProfileService {

    private enum NetworkError: Error {
        case codeError
    }
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastToken: String?

    private func makeUserDataRequest(token: String?) -> URLRequest {
        var url = Constants.defaultBaseUrl
//        var urlComponents = URLComponents(string: "https://api.unsplash.com/me")!
//        urlComponents.queryItems = [
//            URLQueryItem(name: "client_id", value: Constants.accessKey),
//            URLQueryItem(name: "client_secret", value: Constants.secretKey)
//        ]

        url.appendPathComponent("/me")
//        let url = urlComponents.url!
        print("url = ", url)
        var request = URLRequest(url: url)
        if token == token {
            request.setValue(
                "Bearer \(token!)",
                forHTTPHeaderField: "Authorization"
            )
        }

        request.httpMethod = "GET"

//        request.setValue(
//            "application/json;charset=utf-8",
//            forHTTPHeaderField: "Content-Type"
//        )
        print("request = =", request)
        return request
    }

    private func convert(profile: ProfileResult)->Profile{
        let obj = Profile(
            username: profile.userName,
            name: "\(profile.firstName) \(profile.lastName)" ,
            loginName: "@\(profile.userName)" ,
            bio: profile.bio
        )
        return obj
    }


    func fetchProfile(_ token: String?, handler: @escaping (Result<Profile, Error>) -> Void){
//        assert(Thread.isMainThread)
//        if lastToken == token { return }
//        task?.cancel()
//        lastToken = token
        let request = makeUserDataRequest(token: token)
        print("token! =",token!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print("response = = ", response)
            print("data = = ", data)
            if let error = error {
                print("1___")
                handler(.failure(error))
                return
            }

            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 && response.statusCode >= 300 {
                print("2___")
                DispatchQueue.main.async {
                    handler(.failure(NetworkError.codeError))
                    //                        if error != nil {
                    //                            self.lastCode = nil
                    //                        }
                }
            }

            guard let data = data else { return }
            let res = try? JSONDecoder().decode(ProfileResult.self, from: data)
            print("3___")
            guard let res = res else {
                print("3___error")
                DispatchQueue.main.async {
                    handler(.failure(NetworkError.codeError))
                }
                return
            }


            DispatchQueue.main.async {
                print("3.3___")
                handler(.success(self.convert(profile: res)))
                self.task = nil
                if error != nil {
                    self.lastToken = nil
                }
            }
        }
        self.task = task
        task.resume()
    }
}


