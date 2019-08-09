import Foundation

struct Customer: Decodable {
    let id: String
    let creditCards: [CreditCard]

    func with(newCreditCards: [CreditCard]) -> Customer {
        return Customer(id: self.id, creditCards: newCreditCards)
    }
}
