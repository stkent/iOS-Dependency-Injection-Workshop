import UIKit

protocol ConfirmationNavDelegate: AnyObject {
    func resetToLoginScreen()
}

final class ConfirmationViewController: UIViewController {

    @IBOutlet private var confirmationLabel: UILabel!
    
    private let viewModel: ConfirmationViewModel
    private weak var navDelegate: ConfirmationNavDelegate?

    static func build(orderID: OrderID, navDelegate: ConfirmationNavDelegate) -> ConfirmationViewController {
        let viewModel = ConfirmationViewModel(orderID: orderID)
        let viewController = ConfirmationViewController(viewModel, navDelegate)
        viewModel.delegate = viewController
        return viewController
    }

    init(_ viewModel: ConfirmationViewModel, _ navDelegate: ConfirmationNavDelegate) {
        self.viewModel = viewModel
        self.navDelegate = navDelegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func onButtonTapped(_ sender: UIButton) {
        viewModel.onDoneButtonTapped()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onViewDidLoad()
    }

}

extension ConfirmationViewController: ConfirmationViewModelDelegate {
    func confirmationMessage(message: String) {
        confirmationLabel.text = message
    }

    func confirmationAcknowledged() {
        navDelegate?.resetToLoginScreen()
    }
}
