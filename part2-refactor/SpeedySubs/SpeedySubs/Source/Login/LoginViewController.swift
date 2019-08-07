import UIKit

class LoginViewController: UIViewController {

    static func build() -> LoginViewController {
        let viewModel = LoginViewModel()
        let viewController = LoginViewController(viewModel)
        viewModel.delegate = viewController
        return viewController
    }

    private let viewModel: LoginViewModel!

    init(_ viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        print("test")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("2")
    }

}

extension LoginViewController: LoginViewModelDelegate {

}
