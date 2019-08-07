import Foundation

class ChooseSandwichViewModel {

    private weak var delegate: ChooseSandwichViewModelDelegate?

    init(delegate: ChooseSandwichViewModelDelegate) {
        self.delegate = delegate
    }

}

protocol ChooseSandwichViewModelDelegate: AnyObject {

}
