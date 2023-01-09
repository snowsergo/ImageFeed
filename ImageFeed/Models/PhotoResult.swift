import UIKit

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

extension PhotoResult {
    func convert() -> Photo {
        
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            return formatter
        }()
        
        return Photo(
            id: self.id,
            size: CGSize(width: self.width, height: self.height),
            createdAt: dateFormatter.date(from: self.createdAt) ?? Date(),
            welcomeDescription: self.welcomeDescription,
            thumbImageURL: self.urls.thumb,
            largeImageURL: self.urls.full,
            isLiked: self.isLiked
        )
    }
}
