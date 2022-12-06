import UIKit

class ProfileViewController: UIViewController {

    private let profileService = ProfileService()
    private let tokenStorage = OAuth2TokenStorage()


    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var nicknameLabel: UILabel!

    @IBOutlet weak var messageLabel: UILabel!
    
    @IBAction func didTapLogoutButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if tokenStorage.token != nil {
            UIBlockingProgressHUD.show()
            let token = tokenStorage.token;
//            guard token != nil else {return}
            profileService.fetchProfile(token, handler: { [weak self] result in
                guard self != nil else { return }
                switch result {
                case .success:
                    print("result = ", result);
                    UIBlockingProgressHUD.dismiss()
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    print("ошибка при загрузке данных профиля")
                    break
                }
            })
        }

        
    }
    private func displayUserData(profile: Profile) {
        nameLabel.text = profile.name
        nicknameLabel.text = profile.loginName
        messageLabel.text = profile.bio
    }
}
