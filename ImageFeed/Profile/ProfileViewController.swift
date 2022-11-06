import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var nicknameLabel: UILabel!

    @IBOutlet weak var messageLabel: UILabel!
    
    @IBAction func didTapLogoutButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
