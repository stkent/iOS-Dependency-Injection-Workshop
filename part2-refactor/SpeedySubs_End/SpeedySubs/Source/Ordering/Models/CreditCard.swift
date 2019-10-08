import Foundation

struct CreditCard: Codable {
    let id: Int
    let displayName: String
    let expirationDate: DateComponents // Expected to contain year and month components
}
