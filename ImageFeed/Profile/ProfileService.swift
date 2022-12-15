import UIKit

struct ProfileImage: Codable {
    let small: String?
    let medium: String?
    let large: String?
}

struct ProfileResult: Codable{
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    let profileImage: ProfileImage?
    
    enum CodingKeys: String, CodingKey {
        case username
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
    static let shared = ProfileService()
    
    private enum NetworkError: Error {
        case codeError
    }
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastToken: String?
    
    private(set) var profile: Profile?
    
    private func makeUserDataRequest(token: String) -> URLRequest {
        var url = Constants.defaultBaseUrl
        url.appendPathComponent("me")
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfile(_ token: String?, handler: @escaping (Result<ProfileResult, Error>) -> Void){
        assert(Thread.isMainThread)
        guard lastToken != token else { return }
        task?.cancel()
        lastToken = token
        guard let token = token else {
            return
        }
        let request = makeUserDataRequest(token: token)
        let session = URLSession.shared
        
        let fulfillCompletionOnMainThread: (Result<ProfileResult, Error>) -> Void = { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    let convertedProfile = convert(profile: profile)
                    self.profile = Profile(username: convertedProfile.username, name: convertedProfile.name, loginName: convertedProfile.loginName, bio: convertedProfile.bio)
                    handler(result)
                case .failure:
                    self.lastToken = nil
                    self.task?.cancel()
                    handler(.failure(NetworkError.codeError))
                }
            }
        }
        
        let task = session.objectTask(for: request, completion: fulfillCompletionOnMainThread)
        self.task = task
        task.resume()
    }
}


