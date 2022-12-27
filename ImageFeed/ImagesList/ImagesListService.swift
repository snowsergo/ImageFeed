import UIKit

struct UrlsResult: Codable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

struct PhotoResult: Codable {
    let id: String
    let width: Int
    let height: Int
    let welcomeDescription: String?
    let isLiked: Bool
    let createdAt: String
    let urls: UrlsResult

    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case createdAt = "created_at"
        case welcomeDescription = "description"
        case isLiked = "liked_by_user"
        case urls
    }
}

struct LikedPhotoResult: Codable {
    let photo: PhotoResult
}

final class ImageListService {
    static let shared = ImageListService()

    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int = 0

    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    private let notificationCenter = NotificationCenter.default
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    private func makePhotosRequest(pageNumber: Int, token: String) -> URLRequest {
        var urlComponents = URLComponents(string: Constants.getPhotosUrlString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(pageNumber)),
            URLQueryItem(name: "per_page", value: "10"),
        ]

        guard let url = urlComponents.url else {
            fatalError("makeRequest Error")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }

    private func makeLikeChangingRequest(photoId: String, isLike: Bool, token: String) -> URLRequest {
        let urlComponents = URLComponents(string: Constants.getPhotosUrlString)!
        guard var url = urlComponents.url else {
            fatalError("makeRequest Error")
        }
        url.appendPathComponent("/\(photoId)/like")
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchPhotosNextPage(token: String) {
        let fulfillCompletionOnMainThread: (Result<[PhotoResult], Error>) -> Void = { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let images):
                    for image in images {
                        let convertedImage = Photo(
                            id: image.id,
                            size: CGSize(width: image.width, height: image.height),
                            createdAt: self.dateFormatter.date(from: image.createdAt),
                            welcomeDescription:image.welcomeDescription,
                            thumbImageURL: image.urls.thumb,
                            largeImageURL: image.urls.full,
                            isLiked: image.isLiked
                        )
                        self.photos.append(convertedImage);
                    }
                    self.task = nil
                    self.lastLoadedPage += 1
                    self.notificationCenter
                        .post(
                            name: ImageListService.DidChangeNotification,
                            object: self,
                            userInfo: ["PHOTOS": self.photos])
                case .failure(_):
                    self.task = nil
                    return
                }
            }
        }

        if self.task != nil {return}
        let nextPage = lastLoadedPage + 1
        let request = makePhotosRequest(pageNumber: nextPage, token: token)
        let session = URLSession.shared
        let task = session.objectTask(for: request, completion: fulfillCompletionOnMainThread)
        self.task = task
        task.resume()
    }

    func changeLike(
        photoId: String,
        isLike: Bool,
        token: String,
        _ completion: @escaping (_ isLiked: Bool) -> Void
    ) {
        let fulfillCompletionOnMainThread: (Result<LikedPhotoResult, Error>) -> Void = { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {

                        let photo = self.photos[index]

                        let newPhoto = Photo(
                            id: photo.id,
                            size: photo.size,
                            createdAt: photo.createdAt,
                            welcomeDescription:photo.welcomeDescription,
                            thumbImageURL: photo.thumbImageURL,
                            largeImageURL: photo.largeImageURL,
                            isLiked: !photo.isLiked)

                        self.photos[index] = newPhoto
                        completion(!photo.isLiked)
                    }
                    self.task = nil

                case .failure(_):
                    self.task = nil
                    UIBlockingProgressHUD.dismiss()
                    return
                }
            }
        }
        let request = makeLikeChangingRequest(photoId: photoId, isLike: isLike, token: token)
        let session = URLSession.shared
        let task = session.objectTask(for: request, completion: fulfillCompletionOnMainThread)
        self.task = task
        task.resume()
    }
}
