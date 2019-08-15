import Foundation

final class Session {

    static let shared = Session()
    var customer: Customer?
    var order: Order?

    private init() {
        // This initializer intentionally left blank.
    }

}
