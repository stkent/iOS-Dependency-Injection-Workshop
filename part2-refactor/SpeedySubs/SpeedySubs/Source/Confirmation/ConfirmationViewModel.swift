import Foundation

final class ConfirmationViewModel {

    private let orderID: OrderID
    weak var delegate: ConfirmationViewModelDelegate?

    init(orderID: OrderID) {
        self.orderID = orderID
    }

    func onViewDidLoad() {
        delegate?.showConfirmationMessage(message: "Order \(orderID) successfully placed!")
    }

    func onDoneButtonTapped() {
        delegate?.resetToChooseSandwichScreen()
    }

}

protocol ConfirmationViewModelDelegate: AnyObject {
    func showConfirmationMessage(message: String)
    func resetToChooseSandwichScreen()
}
