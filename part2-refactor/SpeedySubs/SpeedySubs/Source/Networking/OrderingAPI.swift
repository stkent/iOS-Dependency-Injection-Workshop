import Foundation

private let networkCallDuration = DispatchTimeInterval.seconds(2)

enum NetworkingError: Error {
    case noInternet
    case serverDown
}

class OrderingAPI {

    func logIn(username: String,
               password: String,
               completionHandler: @escaping (Result<Customer, NetworkingError>) -> ()) {

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + networkCallDuration) {
            let creditCards: [CreditCard] = [
                CreditCard(id: 1, displayName: "Visa 1111", expirationDate: DateComponents(year: 2020, month: 10, day: 31)),
                CreditCard(id: 2, displayName: "Amex 2222", expirationDate: DateComponents(year: 2018, month: 7, day: 31)),
                CreditCard(id: 3, displayName: "Visa 3333", expirationDate: DateComponents(year: 2025, month: 4, day: 30))
            ]

            completionHandler(.success(Customer(id: UUID.init().uuidString, creditCards: creditCards)))
        }
    }

    func getCustomerCreditCards(completionHandler: @escaping (Result<[CreditCard], NetworkingError>) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + networkCallDuration) {
            let creditCards: [CreditCard] = [
                CreditCard(id: 1, displayName: "Visa 1111", expirationDate: DateComponents(year: 2020, month: 10, day: 31)),
                CreditCard(id: 2, displayName: "Amex 2222", expirationDate: DateComponents(year: 2018, month: 7, day: 31)),
                CreditCard(id: 3, displayName: "Visa 3333", expirationDate: DateComponents(year: 2025, month: 4, day: 30)),
                CreditCard(id: 4, displayName: "Amex 4444", expirationDate: DateComponents(year: 2019, month: 12, day: 31))
            ]

            completionHandler(.success(creditCards))
        }
    }

    func getSandwiches(completionHandler: @escaping (Result<[Sandwich], NetworkingError>) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + networkCallDuration) {
            let sandwiches = [
                Sandwich(id: 10, name: "BLT"),
                Sandwich(id: 20, name: "Italian"),
                Sandwich(id: 30, name: "Veggie"),
                Sandwich(id: 40, name: "Philly Cheesesteak"),
                Sandwich(id: 50, name: "Everything")
            ]

            completionHandler(.success(sandwiches))
        }
    }

    func placeOrder(customer: Customer,
                    order: Order,
                    completionHandler: @escaping (Result<Int, NetworkingError>) -> ()) {

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + networkCallDuration) {
            completionHandler(.success(Int.random(in: Int.min...Int.max)))
        }
    }

}