import XCTest
@testable import ImageFeed

final class ProfileViewTests: XCTestCase {

    func testLogOut(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController

        //when
        _ = viewController.view

        let tokenStorage = OAuth2TokenStorage()
        tokenStorage.token="test token"
        viewController.presenter?.logout()
        XCTAssertNil(tokenStorage.token)
    }

    func testUpdateProfileDetails() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController

        //when
        _ = viewController.view

        viewController.updateProfileDetails(name: "Sergey", loginName: "LOGINNAME", bio: "BIO")
        XCTAssertEqual(viewController.nameLabel.text, "Sergey")
        XCTAssertEqual(viewController.nicknameLabel.text, "LOGINNAME")
        XCTAssertEqual(viewController.messageLabel.text, "BIO")
    }
}
