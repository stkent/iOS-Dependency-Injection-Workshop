import Foundation

class ChooseCardViewModel {

    private weak var delegate: ChooseCardViewModelDelegate?

    init(delegate: ChooseCardViewModelDelegate) {
        self.delegate = delegate
    }

}

protocol ChooseCardViewModelDelegate: AnyObject {

}
