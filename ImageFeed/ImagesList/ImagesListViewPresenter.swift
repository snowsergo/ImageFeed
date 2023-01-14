import Foundation

public protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func fetchPhotosNextPage()
    var photos: [Photo] { get set }
    func imageListCellDidTapLike(index:Int, setIsLiked: @escaping (_ isLiked: Bool) -> Void)
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {

    weak var view: ImagesListViewControllerProtocol?
    private let tokenStorage = OAuth2TokenStorage()
    private var imagesListService = ImageListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    var photos: [Photo] = []

    func viewDidLoad() {
        fetchPhotosNextPage()
        UIBlockingProgressHUD.show()
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImageListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                UIBlockingProgressHUD.dismiss()
                self.updateTableViewAnimated()
            }
    }

    func fetchPhotosNextPage() {
        guard let token = tokenStorage.token else {return}
        imagesListService.fetchPhotosNextPage(token: token)
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        guard oldCount != newCount else {return}
        view?.tableView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            view?.tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }

    func imageListCellDidTapLike(index: Int, setIsLiked: @escaping (_ isLiked: Bool) -> Void) {
        guard let token = tokenStorage.token else {return}
        let photo = photos[index]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked, token: token, setIsLiked)
        UIBlockingProgressHUD.dismiss()
    }
}
