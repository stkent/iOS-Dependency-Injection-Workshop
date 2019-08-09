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
        guard isLoginValid else {
            showInvalidLoginAlert()
            return
        }
        
        navDelegate?.advanceToChooseSandwichScreen()
    }
    
    private var isLoginValid: Bool {
        guard let name = nameTextField.text,
            let password = passwordTextField.text else { return false }
        
        return !name.isEmpty && !password.isEmpty
    }
    
    private func showInvalidLoginAlert() {
        let alert = UIAlertController(title: "Login is invalid",
                                      message: "Please enter text in the name and password fields",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true)
    }
    
}
