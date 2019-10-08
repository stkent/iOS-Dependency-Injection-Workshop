import UIKit

protocol ChooseSandwichNavDelegate: AnyObject {
    func advanceToChooseCardScreen()
}

final class ChooseSandwichViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private let viewModel: ChooseSandwichViewModel
    private weak var navDelegate: ChooseSandwichNavDelegate?
    private var displayedSandwiches: [DisplaySandwich] = []

    static func build(navDelegate: ChooseSandwichNavDelegate) -> ChooseSandwichViewController {
        let viewModel = ChooseSandwichViewModel(orderingAPI: OrderingAPI(),
                                                session: Session.shared,
                                                faveStorage: UserDefaultsFaveStorage())
        let viewController = ChooseSandwichViewController(viewModel, navDelegate)
        viewModel.delegate = viewController
        return viewController
    }

    init(_ viewModel: ChooseSandwichViewModel, _ navDelegate: ChooseSandwichNavDelegate) {
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.onViewWillAppear()
    }

}

extension ChooseSandwichViewController: ChooseSandwichViewModelDelegate {
    func displaySandwichLoadState(_ state: ChooseSandwichViewModel.SandwichLoadState) {
        switch state {
        case .loading:
            displayedSandwiches = []
            tableView.reloadData()
            activityIndicator.startAnimating()
        case .loaded(let displaySandwiches):
            activityIndicator.stopAnimating()
            displayedSandwiches = displaySandwiches
            tableView.reloadData()
        case .failed(let error):
            activityIndicator.stopAnimating()
            showInformationalAlert(for: error)
        }
    }

    func goToChooseCreditCardScreen() {
        navDelegate?.advanceToChooseCardScreen()
    }
}

extension ChooseSandwichViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selectedSandwich = displayedSandwiches[indexPath.row].sandwich
        viewModel.onSandwichSelected(selectedSandwich)
    }
}

extension ChooseSandwichViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedSandwiches.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicStyle", for: indexPath)

        let displayedSandwich = displayedSandwiches[indexPath.row]

        cell.textLabel?.text = displayedSandwich.sandwich.name

        if displayedSandwich.favorite {
            let imageView = UIImageView(image: UIImage(named: "favorite-sandwich"))
            cell.accessoryView = imageView
        } else {
            cell.imageView?.image = nil
        }

        return cell
    }
}
