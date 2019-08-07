import Foundation

class ConfirmationViewModel {

    private weak var delegate: ConfirmationViewModelDelegate?

    init(delegate: ConfirmationViewModelDelegate) {
        self.delegate = delegate
    }

}

protocol ConfirmationViewModelDelegate: AnyObject {

}
