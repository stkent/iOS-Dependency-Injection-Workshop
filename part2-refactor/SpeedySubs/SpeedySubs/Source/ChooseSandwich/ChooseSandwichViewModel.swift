import Foundation

final class ChooseSandwichViewModel {

    private static let fakeIdKey = "FAVE_ID"

    weak var delegate: ChooseSandwichViewModelDelegate?

    func onViewWillAppear() {
        delegate?.displaySandwiches([])

        delegate?.showProgressViews()

        OrderingAPI().getSandwiches { [weak self] result in
            self?.delegate?.hideProgressViews()

            switch result {
            case .success(let sandwiches):
                guard let sSelf = self else { return }
                let displaySandwiches = sSelf.getDisplaySandwiches(from: sandwiches)
                sSelf.delegate?.displaySandwiches(displaySandwiches)
            case .failure(let error):
                self?.delegate?.showError(message: error.localizedDescription)
            }
        }
    }

    func onSandwichSelected(sandwich: Sandwich) {
        UserDefaults.standard.set(sandwich.id, forKey: ChooseSandwichViewModel.fakeIdKey)

        let order = Order()
        order.sandwich = sandwich
        // todo: update session

        delegate?.goToChooseCreditCardScreen()
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
    func showProgressViews()
    func hideProgressViews()
    func displaySandwiches(_ sandwiches: [DisplaySandwich])
    func showError(message: String)
    func goToChooseCreditCardScreen()
}

struct DisplaySandwich {
    let sandwich: Sandwich
    let favorite: Bool
}
