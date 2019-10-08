import UIKit

protocol LoginNavDelegate: AnyObject {
    func advanceToChooseSandwichScreen()
}

final class LoginViewController: UIViewController {

    @IBOutlet private var usernameTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    private let viewModel: LoginViewModel
    private weak var navDelegate: LoginNavDelegate?

    static func build(navDelegate: LoginNavDelegate) -> LoginViewController {
        let viewModel = LoginViewModel(orderingAPI: OrderingAPI(), session: Session.shared)
        let viewController = LoginViewController(viewModel, navDelegate)
        viewModel.delegate = viewController
        return viewController
    }

    init(_ viewModel: LoginViewModel, _ navDelegate: LoginNavDelegate) {
        self.viewModel = viewModel
        self.navDelegate = navDelegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func onButtonTapped(_ sender: UIButton) {
        viewModel.onCredentialsSubmitted(username: usernameTextField.text,
                                         password: passwordTextField.text)
    }

}

extension LoginViewController: LoginViewModelDelegate {
    func displayValidationErrorMessage(_ message: String) {
        showInformationalAlert(title: "Invalid input!", message: message)
    }

    func displayProgressViews() {
        activityIndicator.startAnimating()
    }

    func hideProgressViews() {
        activityIndicator.stopAnimating()
    }

    func displayError(_ error: Error) {
        showInformationalAlert(for: error)
    }

    func goToChooseSandwichScreen() {
        navDelegate?.advanceToChooseSandwichScreen()
    }
}
