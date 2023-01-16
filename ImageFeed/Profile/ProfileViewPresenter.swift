import Foundation
import UIKit

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func logout()

}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let tokenStorage = OAuth2TokenStorage()

    func viewDidLoad() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self, let profileImageURL = ProfileImageService.shared.avatarURL else { return }
                self.view?.updateAvatar(profileImageURL: profileImageURL)
                self.view?.removeAnimations()
            }
        if let profileImageURL = profileImageService.avatarURL {
            view?.updateAvatar(profileImageURL: profileImageURL)
        }

        if let profile = profileService.profile {
            view?.updateProfileDetails(name: profile.name, loginName: profile.loginName, bio: profile.bio)
        }

    }

    func logout(){
        tokenStorage.token = nil
        profileService.clean()
    }
}
