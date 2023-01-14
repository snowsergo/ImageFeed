import UIKit
import Kingfisher

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListViewPresenterProtocol? { get set }
    func viewDidLoad()
    var tableView: UITableView! { get set }
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    var presenter: ImagesListViewPresenterProtocol?

    @IBOutlet var tableView: UITableView!
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    private let animationsHelper = AnimationsHelper()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let imagesListViewPresenter = ImagesListViewPresenter()
        presenter = imagesListViewPresenter
        presenter?.view = self
        
        animationsHelper.addImagesListAnimations()
        tableView.delegate = self
        tableView.dataSource = self
        presenter?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            viewController.size = presenter?.photos[indexPath.row].size
            viewController.fullImageUrl = presenter?.photos[indexPath.row].largeImageURL
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.photos.count ?? 0
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row + 1 == presenter?.photos.count {
            presenter?.fetchPhotosNextPage()
        }
    }


    // это точно остается так как меняет внешний вид
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath)  {
        cell.cellImage.layer.addSublayer(animationsHelper.gradient)
        guard let url = URL(string: (presenter?.photos[indexPath.row].thumbImageURL)!) else {return}
        let processor = RoundCornerImageProcessor(cornerRadius: 16)
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"), options: [.processor(processor)]){ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.animationsHelper.removeImagesListAnimations()
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure(let error):
                print(error)
            }
        }
        
        let date = presenter?.photos[indexPath.row].createdAt
        cell.dateLabel.text = dateFormatter.string(from: date!)
        let isLiked = presenter?.photos[indexPath.row].isLiked ?? false
        let buttonImage = isLiked ? UIImage(named: "like-active") : UIImage(named: "like-no-active")
        cell.likeButton.setImage(buttonImage, for: .normal)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.delegate = self
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDataSource{}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {

    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter?.imageListCellDidTapLike(index: indexPath.row,  setIsLiked: cell.setIsLiked)
    }
}
