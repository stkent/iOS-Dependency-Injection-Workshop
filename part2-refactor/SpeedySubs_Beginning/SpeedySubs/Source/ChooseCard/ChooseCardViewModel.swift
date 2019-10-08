import Foundation

final class ChooseCardViewModel {

    weak var delegate: ChooseCardViewModelDelegate?

    func onViewWillAppear() {
        displayCreditCards()
    }

    func onCreditCardSelected(creditCard: CreditCard) {
        delegate?.displayProgressViews()

        let customer = Session.shared.customer!
        let order = Session.shared.order!.with(newCreditCard: creditCard)
        Session.shared.order = order

        OrderingAPI().placeOrder(
            customer: customer,
            order: order) { [weak self] result in
                switch result {
                case .success(let orderID):
                    Session.shared.order = nil

                    guard let sSelf = self else { return }

                    sSelf.delegate?.hideProgressViews()

                    sSelf.delegate?.goToConfirmationScreenWithOrderID(orderID)
                case .failure(let error):
                    guard let sSelf = self else { return }

                    sSelf.delegate?.hideProgressViews()
                    sSelf.delegate?.displayPlaceOrderError(error)
                }
        }
    }

    func onRefreshRequested() {
        OrderingAPI().getCustomerCreditCards { [weak self] result in
            switch result {
            case .success(let creditCards):
                let updatedCustomer = Session.shared.customer?.with(newCreditCards: creditCards)
                Session.shared.customer = updatedCustomer

                guard let sSelf = self else { return }

                sSelf.delegate?.endRefreshing()
                sSelf.displayCreditCards()
            case .failure(let error):
                guard let sSelf = self else { return }

                sSelf.delegate?.endRefreshing()
                sSelf.delegate?.displayRefreshFailedError(error)
            }
        }
    }

    private func displayCreditCards() {
        let today = Calendar.current.dateComponents([.year, .month], from: Date())

        let nonExpiredCreditCards = Session.shared.customer?.creditCards
            .filter { card in
                let expiry = card.expirationDate
                return expiry.year! > today.year! || (expiry.year! == today.year! && expiry.month! >= today.month!)
            } ?? []

        delegate?.displayCards(nonExpiredCreditCards)
    }

}

protocol ChooseCardViewModelDelegate: AnyObject {
    func displayCards(_ cards: [CreditCard])
    func displayProgressViews()
    func hideProgressViews()
    func endRefreshing()
    func displayRefreshFailedError(_ error: Error)
    func displayPlaceOrderError(_ error: Error)
    func goToConfirmationScreenWithOrderID(_ orderID: OrderID)
}
