import UIKit

protocol LoginNavDelegate: AnyObject {
    func advanceToChooseSandwichScreen()
}

final class LoginViewController: UIViewController {

    unowned let navDelegate: LoginNavDelegate

    @IBAction func onButtonTapped(_ sender: UIButton) {
        navDelegate.advanceToChooseSandwichScreen()
    }

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

}
