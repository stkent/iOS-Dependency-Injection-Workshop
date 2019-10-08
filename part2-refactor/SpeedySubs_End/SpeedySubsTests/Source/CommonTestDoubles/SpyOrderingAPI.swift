@testable import SpeedySubs

class SpyOrderingAPI: IOrderingAPI {
    var logInResult: Result<Customer, NetworkingError>?
    var getCustomerCreditCardsResult: Result<[CreditCard], NetworkingError>?
    var getSandwichesResult: Result<[Sandwich], NetworkingError>?
    var placeOrderResult: Result<OrderID, NetworkingError>?

    private(set) var logInCallCount = 0
    private(set) var logInLastUsername: String?
    private(set) var logInLastPassword: String?
    private(set) var getCustomerCreditCardsCallCount = 0
    private(set) var getSandwichesCallCount = 0
    private(set) var placeOrderCallCount = 0

    func logIn(username: String, password: String, completionHandler: @escaping (Result<Customer, NetworkingError>) -> ()) {
        logInCallCount += 1
        logInLastUsername = username
        logInLastPassword = password

        if let result = logInResult {
            completionHandler(result)
        }
    }

    func getCustomerCreditCards(completionHandler: @escaping (Result<[CreditCard], NetworkingError>) -> ()) {
        getCustomerCreditCardsCallCount += 1

        if let result = getCustomerCreditCardsResult {
            completionHandler(result)
        }
    }

    func getSandwiches(completionHandler: @escaping (Result<[Sandwich], NetworkingError>) -> ()) {
        getSandwichesCallCount += 1

        if let result = getSandwichesResult {
            completionHandler(result)
        }
    }

    func placeOrder(customer: Customer, order: Order, completionHandler: @escaping (Result<OrderID, NetworkingError>) -> ()) {
        placeOrderCallCount += 1

        if let result = placeOrderResult {
            completionHandler(result)
        }
    }
}
