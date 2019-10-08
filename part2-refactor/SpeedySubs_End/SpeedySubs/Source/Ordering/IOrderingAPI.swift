import Foundation

protocol IOrderingAPI {
    func logIn(username: String,
               password: String,
               completionHandler: @escaping (Result<Customer, NetworkingError>) -> ())

    func getCustomerCreditCards(completionHandler: @escaping (Result<[CreditCard], NetworkingError>) -> ())

    func getSandwiches(completionHandler: @escaping (Result<[Sandwich], NetworkingError>) -> ())

    func placeOrder(customer: Customer,
                    order: Order,
                    completionHandler: @escaping (Result<OrderID, NetworkingError>) -> ())
}
