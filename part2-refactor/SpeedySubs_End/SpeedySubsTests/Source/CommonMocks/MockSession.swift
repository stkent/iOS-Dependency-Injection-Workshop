import XCTest
@testable import SpeedySubs

class MockSession: ISession {
    var customer: Customer?
    var order: Order?
}
