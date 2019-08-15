import Foundation
import UIKit

extension UIViewController {

    func showInformationalAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK",
                                      style: .cancel,
                                      handler: nil))

        present(alert, animated: true)
    }

    func showInformationalAlert(for error: Error) {
        let alert = UIAlertController(title: "Error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK",
                                      style: .cancel,
                                      handler: nil))

        present(alert, animated: true)
    }

}
