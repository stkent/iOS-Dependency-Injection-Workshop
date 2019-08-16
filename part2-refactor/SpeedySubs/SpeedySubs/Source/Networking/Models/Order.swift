import Foundation

final class Order: Encodable {
    var sandwich: Sandwich?
    var creditCard: CreditCard?
}
