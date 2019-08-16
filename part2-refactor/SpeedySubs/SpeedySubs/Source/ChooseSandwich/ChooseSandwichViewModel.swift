import Foundation

final class ChooseSandwichViewModel {

    enum SandwichLoadState {
        case loading
        case loaded(_ displaySandwiches: [DisplaySandwich])
        case failed(_ error: Error)
    }

    private static let fakeIdKey = "FAVE_ID"

    weak var delegate: ChooseSandwichViewModelDelegate?

    func onViewWillAppear() {
        delegate?.sandwichLoadStateChanged(.loading)

        OrderingAPI().getSandwiches { [weak self] result in
            switch result {
            case .success(let sandwiches):
                guard let sSelf = self else { return }
                let displaySandwiches = sSelf.getDisplaySandwiches(from: sandwiches)
                sSelf.delegate?.sandwichLoadStateChanged(.loaded(displaySandwiches))
            case .failure(let error):
                self?.delegate?.sandwichLoadStateChanged(.failed(error))
            }
        }
    }

    func onSandwichSelected(sandwich: Sandwich) {
        UserDefaults.standard.set(sandwich.id, forKey: ChooseSandwichViewModel.fakeIdKey)

        let order = Order()
        order.sandwich = sandwich
        Session.shared.order = order

        delegate?.sandwichSelectionCompleted()
    }

    private func getDisplaySandwiches(from sandwiches: [Sandwich]) -> [DisplaySandwich] {
        let favoriteId = UserDefaults.standard.value(forKey: ChooseSandwichViewModel.fakeIdKey) as? Int

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
    func sandwichLoadStateChanged(_ state: ChooseSandwichViewModel.SandwichLoadState)
    func sandwichSelectionCompleted()
}

struct DisplaySandwich {
    let sandwich: Sandwich
    let favorite: Bool
}
