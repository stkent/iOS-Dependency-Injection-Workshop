import UIKit

protocol ChooseCardNavDelegate: AnyObject {
    func advanceToConfirmationScreen(orderID: OrderID)
}

final class ChooseCardViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    private var refreshControl = UIRefreshControl()

    private let viewModel: ChooseCardViewModel
    private weak var navDelegate: ChooseCardNavDelegate?
    private var displayedCards: [CreditCard] = []

    static func build(navDelegate: ChooseCardNavDelegate) -> ChooseCardViewController {
        let viewModel = ChooseCardViewModel()
        let viewController = ChooseCardViewController(viewModel, navDelegate)
        viewModel.delegate = viewController
        return viewController
    }

    init(_ viewModel: ChooseCardViewModel, _ navDelegate: ChooseCardNavDelegate) {
        self.viewModel = viewModel
        self.navDelegate = navDelegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 56
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "basicStyle")
        tableView.refreshControl = refreshControl

        refreshControl.addTarget(self, action: #selector(onRefreshTriggered), for: .valueChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.onViewWillAppear()
    }

    @objc private func onRefreshTriggered() {
        viewModel.onRefreshRequested()
    }

}

extension ChooseCardViewController: ChooseCardViewModelDelegate {
    func displayCards(_ cards: [CreditCard]) {
        displayedCards = cards
        tableView.reloadData()
    }

    func displayProgressViews() {
        activityIndicator.startAnimating()
    }

    func hideProgressViews() {
        activityIndicator.stopAnimating()
    }

    func endRefreshing() {
        refreshControl.endRefreshing()
    }

    func displayRefreshFailedError(_ error: Error) {
        showInformationalAlert(for: error)
    }

    func displayPlaceOrderError(_ error: Error) {
        showInformationalAlert(for: error)
    }

    func goToConfirmationScreenWithOrderID(_ orderID: OrderID) {
        navDelegate?.advanceToConfirmationScreen(orderID: orderID)
    }
}

extension ChooseCardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedCard = displayedCards[indexPath.row]
        viewModel.onCreditCardSelected(creditCard: selectedCard)
    }
}

extension ChooseCardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedCards.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicStyle", for: indexPath)

        let displayedCard = displayedCards[indexPath.row]
        cell.textLabel?.text = displayedCard.displayName

        return cell
    }
}
