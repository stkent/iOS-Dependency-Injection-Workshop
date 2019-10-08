import Foundation

final class ChooseSandwichViewModel {

    enum SandwichLoadState {
        case loading
        case loaded(_ displaySandwiches: [DisplaySandwich])
        case failed(_ error: Error)
    }

    private static let faveIDKey = "FAVE_ID"

    weak var delegate: ChooseSandwichViewModelDelegate?
 
    func onViewWillAppear() {
        delegate?.displaySandwichLoadState(.loading)

        OrderingAPI().getSandwiches { [weak self] result in
            switch result {
            case .success(let sandwiches):
                guard let sSelf = self else { return }
                let displaySandwiches = sSelf.getDisplaySandwiches(from: sandwiches)
                sSelf.delegate?.displaySandwichLoadState(.loaded(displaySandwiches))
            case .failure(let error):
                self?.delegate?.displaySandwichLoadState(.failed(error))
            }
        }
    }

    func onSandwichSelected(_ sandwich: Sandwich) {
        UserDefaults.standard.set(sandwich.id, forKey: ChooseSandwichViewModel.faveIDKey)

        let order = Order(sandwich: sandwich, creditCard: nil)
        Session.shared.order = order

        delegate?.goToChooseCreditCardScreen()
    }

    private func getDisplaySandwiches(from sandwiches: [Sandwich]) -> [DisplaySandwich] {
        let favoriteId = UserDefaults.standard.value(forKey: ChooseSandwichViewModel.faveIDKey) as? Int

        var result: [DisplaySandwich] = []

        for sandwich in sandwiches {
            if sandwich.id == favoriteId {
                // Insert favorite at the front of the list.
                result.insert(DisplaySandwich(sandwich: sandwich, favorite: true), at: 0)
            } else {
                // Insert non-favorite at the end of the list.
                result.append(DisplaySandwich(sandwich: sandwich, favorite: false))
            }
        }

        return result
    }

}

protocol ChooseSandwichViewModelDelegate: AnyObject {
    func displaySandwichLoadState(_ state: ChooseSandwichViewModel.SandwichLoadState)
    func goToChooseCreditCardScreen()
}

struct DisplaySandwich {
    let sandwich: Sandwich
    let favorite: Bool
}
