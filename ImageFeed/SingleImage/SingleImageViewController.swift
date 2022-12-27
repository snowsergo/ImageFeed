import UIKit
import Kingfisher

class SingleImageViewController: UIViewController {
    var fullImageUrl: String? = nil
    var size: CGSize? = nil
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        let share = UIActivityViewController(
            activityItems: [imageView.image!],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let fullUrl = fullImageUrl, let size = size else {
            return
        }
        let url = URL(string: "\(fullUrl)")
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder-icon"), options: [])
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        rescaleAndCenterImageInScrollView(size: size)
    }
    
    private func rescaleAndCenterImageInScrollView(size: CGSize) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        let visibleRectSize = view.bounds.size
        let hScale = visibleRectSize.width / size.width
        let vScale = visibleRectSize.height / size.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard let size = size else {return}
        rescaleAndCenterImageInScrollView(size: size)
    }
}
