import Foundation

struct CreditCard: Codable {
    let id: Int
    let displayName: String
    let expirationDate: DateComponents // Expected to contain year, month, and date components
}
