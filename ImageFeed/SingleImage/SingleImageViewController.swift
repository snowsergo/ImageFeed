import UIKit
import Kingfisher
import SwiftUI

//struct MyIndicator: Indicator {
//    let view: UIView = UIActivityIndicatorView(style: .whiteLarge)
//
//    func startAnimatingView() { view.isHidden = false }
//    func stopAnimatingView() { view.isHidden = true }
//
//    init() {
//        view.backgroundColor = .red
//    }
//}

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
        scrollView.minimumZoomScale = 1
//        scrollView.maximumZoomScale = 1
//        rescaleAndCenterImageInScrollView(size: size)
        let url = URL(string: "\(fullUrl)")
//        let i = MyIndicator()
//        imageView.kf.indicatorType = .custom(indicator: i)
        imageView.kf.setImage(with: url, placeholder: UIImage(named: "placeholder-icon"), options: []){ [self] result in
            switch result {
            case .success:
                scrollView.minimumZoomScale = 0.1
                scrollView.maximumZoomScale = 1.25
                rescaleAndCenterImageInScrollView(size: size)
            case .failure(let error):
                print(error)
            }
        }
//        scrollView.minimumZoomScale = 0.1
//        scrollView.maximumZoomScale = 1.25
//        rescaleAndCenterImageInScrollView(size: size)
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        scrollView.minimumZoomScale = 0.1
//        scrollView.maximumZoomScale = 1.25
//        guard let size = size else {
//            return
//        }
//        rescaleAndCenterImageInScrollView(size: size)
//    }
    
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
