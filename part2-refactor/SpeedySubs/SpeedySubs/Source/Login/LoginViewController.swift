import UIKit

protocol LoginNavDelegate: AnyObject {
    func advanceToChooseSandwichScreen()
}

final class LoginViewController: UIViewController {

    private weak var navDelegate: LoginNavDelegate?
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    init(navDelegate: LoginNavDelegate) {
        self.navDelegate = navDelegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text,
              let password = passwordTextField.text,
              !name.isEmpty,
              !password.isEmpty else {

                  showInvalidLoginAlert()
                  return
        }

        // todo: show progress indicator

        OrderingAPI().logIn(username: name, password: password) { [weak self] result in
            // todo: hide progress indicator

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
