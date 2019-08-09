import Foundation

class Order: Encodable {
    var sandwich: Sandwich? = nil
    var creditCard: CreditCard? = nil
}
