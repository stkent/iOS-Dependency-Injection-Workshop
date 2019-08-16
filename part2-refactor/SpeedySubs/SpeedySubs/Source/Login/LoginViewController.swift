import UIKit

protocol LoginNavDelegate: AnyObject {
    func advanceToChooseSandwichScreen()
}

final class LoginViewController: UIViewController {

    private weak var navDelegate: LoginNavDelegate?
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    init(navDelegate: LoginNavDelegate) {
        self.navDelegate = navDelegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func onButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text,
              let password = passwordTextField.text,
              !name.isEmpty,
              !password.isEmpty else {

                  showInvalidLoginAlert()
                  return
        }

        activityIndicator.startAnimating()

        OrderingAPI().logIn(username: name, password: password) { [weak self] result in
            self?.activityIndicator.stopAnimating()

            switch result {
            case .success(let customer):
                Session.shared.customer = customer
                self?.navDelegate?.advanceToChooseSandwichScreen()
            case .failure(let error):
                Session.shared.customer = nil
                self?.showInformationalAlert(for: error)
                break
            }
        }
    }

    private func showInvalidLoginAlert() {
        showInformationalAlert(title: "Login is invalid",
                               message: "Please enter text in the name and password fields")
    }

}
