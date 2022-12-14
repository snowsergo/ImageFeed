import Foundation

final class ProfileImageService {
    
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    static let shared = ProfileImageService()
    private (set) var avatarURL: String?
    private let profileService = ProfileService.shared
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastToken: String?
    private let notificationCenter = NotificationCenter.default
    private enum NetworkError: Error {
        case codeError
    }
    
    private func makeUserImageRequest(username:String, token: String) -> URLRequest {
        var url = Constants.defaultBaseUrl
        url.appendPathComponent("/users/\(username)")
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfileImageURL(
        username: String,
        token: String?,
        _ completion: @escaping (Result<UserResult, Error>) -> Void) {
            assert(Thread.isMainThread)
            guard lastToken != token else {return}
            task?.cancel()
            lastToken = token
            guard let token = token, let _ = profileService.profile else {
                return
            }
            
            let fulfillCompletionOnMainThread: (Result<UserResult, Error>) -> Void = { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    defer { completion(result) }
                    guard case .success(let image) = result else { return }
                    self.avatarURL = image.profileImage?.medium
                }
                if let url = self.avatarURL {
                    self.notificationCenter
                        .post(
                            name: ProfileImageService.DidChangeNotification,
                            object: self,
                            userInfo: ["URL": url])
                }
            }
            
            let request = makeUserImageRequest(username: username, token: token)
            let session = URLSession.shared
            let task = session.objectTask(for: request, completion: fulfillCompletionOnMainThread)
            self.task = task
            task.resume()
        }
}
