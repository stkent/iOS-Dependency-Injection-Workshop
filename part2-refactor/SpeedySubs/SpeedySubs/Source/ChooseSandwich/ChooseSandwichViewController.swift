import UIKit

protocol ChooseSandwichNavDelegate: AnyObject {
    func advanceToChooseCardScreen()
}

class ChooseSandwichViewController: UIViewController {

    static func build(navDelegate: ChooseSandwichNavDelegate) -> ChooseSandwichViewController {
        let viewModel = ChooseSandwichViewModel()
        let viewController = ChooseSandwichViewController(viewModel)
        viewModel.delegate = viewController
        return viewController
    }

    private let viewModel: ChooseSandwichViewModel

    init(_ viewModel: ChooseSandwichViewModel) {
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

extension ChooseSandwichViewController: ChooseSandwichViewModelDelegate {

}
