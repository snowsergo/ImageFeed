import UIKit

class AuthViewController: UIViewController, WebViewViewControllerDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){

    }

    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }

    private let ShowWebViewSegueIdentifier = "ShowWebView"
}
