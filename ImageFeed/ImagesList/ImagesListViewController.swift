import UIKit

class ImagesListViewController: UIViewController {

    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    private var photosName = [String]()

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }

    func configCell(for cell: ImagesListCell, with indexPath: IndexPath)  {
        let imageName = photosName[indexPath.row]

        guard let image = UIImage(named: imageName) else {
            return
        }

        cell.cellImage.image = image
        cell.dateLabel.text = dateFormatter.string(from: Date())

        let isLiked = indexPath.row % 2 == 0
        let buttonImage = isLiked ? UIImage(named: "like-active") : UIImage(named: "like-no-active")
        cell.likeButton.setImage(buttonImage, for: .normal)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)

        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }

        configCell(for: imageListCell, with: indexPath)
        return imageListCell
        }


    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        photosName = Array(0..<20).map{ "\($0)" }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == ShowSingleImageSegueIdentifier { // 1
               let viewController = segue.destination as! SingleImageViewController // 2
               let indexPath = sender as! IndexPath // 3
               let image = UIImage(named: photosName[indexPath.row]) // 4
//               _ = viewController.view // CRASH FIXED !?
               viewController.image = image // 5
           } else {
               super.prepare(for: segue, sender: sender) // 6
           }
       }
}

extension ImagesListViewController: UITableViewDataSource{

}
//extension ImagesListViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
//}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
}
