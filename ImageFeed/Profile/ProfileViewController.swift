import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func updateAvatar(profileImageURL: String)
    func removeAnimations()
    func updateProfileDetails(name: String, loginName: String, bio: String?)
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?
    private let ShowSplashViewIdentifier = "ShowSplashView"
    private let animationsHelper = AnimationsHelper()

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    @IBAction private func didTapLogoutButton(_ sender: Any) {
        presenter?.logout()
        performSegue(withIdentifier: ShowSplashViewIdentifier, sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let profileViewPresenter = ProfileViewPresenter()
        presenter = profileViewPresenter
        presenter?.view = self
        animationsHelper.addAnimations()
        profileImageView.layer.addSublayer(animationsHelper.gradient)
        nameLabel.layer.addSublayer(animationsHelper.gradient2)
        nicknameLabel.layer.addSublayer(animationsHelper.gradient3)
        messageLabel.layer.addSublayer(animationsHelper.gradient4)
        presenter?.viewDidLoad()
    }

    func removeAnimations(){
        animationsHelper.removeAvatarAnimations()
        animationsHelper.removeTextAnimations()
    }

    func updateAvatar(profileImageURL: String) {
        guard
            let url = URL(string: profileImageURL)
        else {
            return
        }
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        profileImageView.kf.setImage(with:url, options: [.processor(processor)])
        animationsHelper.removeAvatarAnimations()
    }
    func updateProfileDetails(name: String, loginName: String, bio: String?) {
        nameLabel.text = name
        nicknameLabel.text = loginName
        messageLabel.text = bio
        animationsHelper.removeTextAnimations()
    }
}
