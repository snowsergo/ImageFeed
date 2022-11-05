import UIKit

class SingleImageViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!

//    var image: UIImage!
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return } // 1
            imageView.image = image // 2
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
