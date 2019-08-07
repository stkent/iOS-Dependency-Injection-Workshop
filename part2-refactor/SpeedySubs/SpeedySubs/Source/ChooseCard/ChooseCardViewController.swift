import UIKit

protocol ChooseCardNavDelegate: AnyObject {
    func advanceToConfirmationScreen()
}

class ChooseCardViewController: UIViewController {

    static func build(navDelegate: ChooseCardNavDelegate) -> ChooseCardViewController {
        let viewModel = ChooseCardViewModel()
        let viewController = ChooseCardViewController(viewModel)
        viewModel.delegate = viewController
        return viewController
    }

    private let viewModel: ChooseCardViewModel

    init(_ viewModel: ChooseCardViewModel) {
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

extension ChooseCardViewController: ChooseCardViewModelDelegate {

}
