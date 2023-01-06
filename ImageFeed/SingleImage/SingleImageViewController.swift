import UIKit
import Kingfisher
import SwiftUI


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
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder-icon"), options: []){ [weak self] result in
            guard let self = self else { return }
            defer { UIBlockingProgressHUD.dismiss() }
            guard case .success(_) = result else { return }
            self.scrollView.minimumZoomScale = 0.1
            self.scrollView.maximumZoomScale = 1.25
            self.rescaleAndCenterImageInScrollView(size: size)
        }
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 1
        rescaleAndCenterImageInScrollView(size: size)
    }
    
    private func rescaleAndCenterImageInScrollView(size: CGSize) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
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
}
