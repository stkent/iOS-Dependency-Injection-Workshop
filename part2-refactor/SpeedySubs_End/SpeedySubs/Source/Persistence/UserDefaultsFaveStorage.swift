import Foundation

class UserDefaultsFaveStorage: IFaveStorage {

    private static let faveIDKey = "FAVE_ID"

    var favoriteSandwichId: Int? {
        get {
            return UserDefaults.standard.value(forKey: UserDefaultsFaveStorage.faveIDKey) as? Int
        }
        set(newId) {
            UserDefaults.standard.set(newId, forKey: UserDefaultsFaveStorage.faveIDKey)
        }
    }
}
