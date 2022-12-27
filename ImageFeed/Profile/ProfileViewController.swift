import UIKit
import Kingfisher
import WebKit

class ProfileViewController: UIViewController {
    private let ShowSplashViewIdentifier = "ShowSplashView"
    private let profileService = ProfileService.shared
    private let tokenStorage = OAuth2TokenStorage()

    private var profileImageServiceObserver: NSObjectProtocol?

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBAction func didTapLogoutButton(_ sender: Any) {
        tokenStorage.token = nil
        ProfileViewController.clean()
        performSegue(withIdentifier: ShowSplashViewIdentifier, sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
        guard let profile = profileService.profile else {
            return
        }
        updateProfileDetails(profile: profile)
    }
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else {
            return
        }
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        profileImageView.kf.setImage(with:url, options: [.processor(processor)])
    }
    
    private func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name
        nicknameLabel.text = profile.loginName
        messageLabel.text = profile.bio
    }

    static func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}
