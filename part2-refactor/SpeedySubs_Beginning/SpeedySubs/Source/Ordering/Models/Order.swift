import Foundation

struct Order: Encodable {
    let sandwich: Sandwich?
    let creditCard: CreditCard?

    func with(newSandwich: Sandwich) -> Order {
        return Order(sandwich: newSandwich, creditCard: creditCard)
    }

    func with(newCreditCard: CreditCard) -> Order {
        return Order(sandwich: sandwich, creditCard: newCreditCard)
    }
}
