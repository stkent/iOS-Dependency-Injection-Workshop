import Foundation

final class ConfirmationViewModel {

    private let orderID: OrderID
    weak var delegate: ConfirmationViewModelDelegate?

    init(orderID: OrderID) {
        self.orderID = orderID
    }

    func onViewDidLoad() {
        delegate?.confirmationMessage(message: "Order \(orderID) successfully placed!")
    }

    func onDoneButtonTapped() {
        delegate?.confirmationAcknowledged()
    }

}

protocol ConfirmationViewModelDelegate: AnyObject {
    func confirmationMessage(message: String)
    func confirmationAcknowledged()
}
