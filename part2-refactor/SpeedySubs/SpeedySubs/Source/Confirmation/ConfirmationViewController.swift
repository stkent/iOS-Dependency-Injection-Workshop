import UIKit

final class ConfirmationViewController: UIViewController {
    
    private let viewModel: ConfirmationViewModel

    static func build(navDelegate: ChooseSandwichNavDelegate) -> ConfirmationViewController {
        let viewModel = ConfirmationViewModel()
        let viewController = ConfirmationViewController(viewModel)
        viewModel.delegate = viewController
        return viewController
    }

    init(_ viewModel: ConfirmationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension ConfirmationViewController: ConfirmationViewModelDelegate {

}
