import UIKit

final class ImageListService {
    static let shared = ImageListService()

    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?

    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    private let notificationCenter = NotificationCenter.default
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")


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
        print("____запросили страницу ! lastLoadedPage = ", lastLoadedPage)
        let fulfillCompletionOnMainThread: (Result<[PhotoResult], Error>) -> Void = { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let images):
                    let newPhotos = images.map { $0.convert() }
                    self.photos.append(contentsOf: newPhotos);
                    self.task = nil
                    if self.lastLoadedPage != nil  {
                        self.lastLoadedPage! += 1
                    } else {
                        self.lastLoadedPage = 1
                    }

                    self.notificationCenter
                        .post(
                            name: ImageListService.didChangeNotification,
                            object: self,
                            userInfo: ["PHOTOS": self.photos])
                case .failure(_):
                    self.task = nil
                }
            }
        }

        if self.task != nil {
            print("уже есть запрос")
            return }
        //        let nextPage = lastLoadedPage + 1
        let nextPage = lastLoadedPage == nil
        ? 1
        : lastLoadedPage! + 1
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
