import Foundation

final class LoginViewModel {

    weak var delegate: LoginViewModelDelegate?
    private let orderingAPI: IOrderingAPI
    private var session: ISession

    init(orderingAPI: IOrderingAPI, session: ISession) {
        self.orderingAPI = orderingAPI
        self.session = session
    }

    func onCredentialsSubmitted(username: String?, password: String?) {
        guard let username = username, !username.isEmpty else {
            delegate?.displayValidationErrorMessage("Username cannot be blank")
            return
        }

        guard let password = password, !password.isEmpty else {
            delegate?.displayValidationErrorMessage("Password cannot be blank")
            return
        }

        self.delegate?.displayProgressViews()

        orderingAPI.logIn(username: username, password: password) { result in
            self.delegate?.hideProgressViews()

            switch result {
            case .success(let customer):
                self.session.customer = customer
                self.delegate?.goToChooseSandwichScreen()
            case .failure(let error):
                self.session.customer = nil
                self.delegate?.displayError(error)
                break
            }
        }
    }

}

protocol LoginViewModelDelegate: AnyObject {
    func displayValidationErrorMessage(_ message: String)
    func displayProgressViews()
    func hideProgressViews()
    func displayError(_ error: Error)
    func goToChooseSandwichScreen()
}
