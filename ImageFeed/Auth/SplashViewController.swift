import UIKit

class SplashViewController: UIViewController{
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuth"
    private let authService = OAuth2Service()
    private let tokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var alertPresenter = AlertPresenter()


    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        startAuth()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    private func startAuth() {
        if let token = tokenStorage.token {
            self.fetchProfile(token: token)
        } else {
            performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }

    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(ShowAuthenticationScreenSegueIdentifier)") }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            UIBlockingProgressHUD.show()
            self?.fetchOAuthToken(code)
        }
    }
    private func fetchOAuthToken(_ code: String) {
        authService.fetchAuthToken(code:code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let res):
                self.tokenStorage.token = res.accessToken
                self.fetchProfile(token: res.accessToken)
            case .failure:
                self.showAlert()
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
                self.profileImageService.fetchProfileImageURL(
                    username: profile.username,
                    token: token) { _ in }
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showAlert()
            }
        }
    }
    
    func showAlert() {
        print("___ показываем алерт")
        alertPresenter.showAlert(
            title: "Что-то пошло не так",
            text: "Не удалось войти в систему",
            buttonText: "Попробовать еще раз",
            controller: self,
            callback: startAuth
        )
    }
}
