import UIKit

protocol AlertPresenterProtocol {
    func showAlert(title: String?, text: String?, buttonText: String?, controller: UIViewController)
}

class AlertPresenter: AlertPresenterProtocol {
    func showAlert(title: String?, text: String?, buttonText: String?, controller: UIViewController) {
        let alert = UIAlertController(
            title: title,
            message: text,
            preferredStyle: .alert
        )
        alert.view.accessibilityIdentifier = "result_alert"
        let action = UIAlertAction(
            title: buttonText,
            style: .default, handler: {_ in })
        alert.addAction(action)

        controller.present(alert, animated: true, completion: nil)
    }
}
