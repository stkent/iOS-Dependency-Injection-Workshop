import XCTest
@testable import SpeedySubs

class ChooseSandwichViewModelTests: XCTestCase {

    private var spyOrderingAPI: SpyOrderingAPI!
    private var testSession: TestSession!
    private var fakeFaveStorage: FakeFaveStorage!
    private var spyDelegate: SpyDelegate!
    private var viewModel: ChooseSandwichViewModel!

    override func setUp() {
        spyOrderingAPI = SpyOrderingAPI()
        testSession = TestSession()
        fakeFaveStorage = FakeFaveStorage()
        spyDelegate = SpyDelegate()
        viewModel = ChooseSandwichViewModel(orderingAPI: spyOrderingAPI, session: testSession, faveStorage: fakeFaveStorage)
        viewModel.delegate = spyDelegate
    }

    func testSandwichLoadCallIsMadeWhenScreenAppears() {
        // Act
        viewModel.onViewWillAppear()

        // Assert
        XCTAssertEqual(1, spyOrderingAPI.getSandwichesCallCount)
    }

    func testStoredFaveIsUpdatedWhenUserSelectsASandwich() {
        // Arrange
        let sandwichToSelect = Sandwich(id: 456, name: "Test Sandwich 456")

        let getSandwichesResult: Result<[Sandwich], NetworkingError> = .success([
            Sandwich(id: 123, name: "Test Sandwich 123"),
            sandwichToSelect,
            Sandwich(id: 789, name: "Test Sandwich 789")
        ])

        spyOrderingAPI.getSandwichesResult = getSandwichesResult

        // Act
        viewModel.onViewWillAppear()
        viewModel.onSandwichSelected(sandwichToSelect)

        // Assert
        XCTAssertEqual(sandwichToSelect.id, fakeFaveStorage.favoriteSandwichId)
    }

    func testOrderIsUpdatedCorrectlyWhenUserSelectsASandwich() {
        // Arrange
        let sandwichToSelect = Sandwich(id: 456, name: "Test Sandwich 456")

        let getSandwichesResult: Result<[Sandwich], NetworkingError> = .success([
            Sandwich(id: 123, name: "Test Sandwich 123"),
            sandwichToSelect,
            Sandwich(id: 789, name: "Test Sandwich 789")
        ])

        spyOrderingAPI.getSandwichesResult = getSandwichesResult

        // Act
        viewModel.onViewWillAppear()
        viewModel.onSandwichSelected(sandwichToSelect)

        // Assert
        XCTAssertEqual(sandwichToSelect.id, testSession.order?.sandwich?.id)
    }

    func testNavigationOccursWhenUserSelectsASandwich() {
        // Arrange
        let sandwichToSelect = Sandwich(id: 456, name: "Test Sandwich 456")

        let getSandwichesResult: Result<[Sandwich], NetworkingError> = .success([
            Sandwich(id: 123, name: "Test Sandwich 123"),
            sandwichToSelect,
            Sandwich(id: 789, name: "Test Sandwich 789")
        ])

        spyOrderingAPI.getSandwichesResult = getSandwichesResult

        // Act
        viewModel.onViewWillAppear()
        viewModel.onSandwichSelected(sandwichToSelect)

        // Assert
        XCTAssertEqual(1, spyDelegate.goToChooseCreditCardScreenCallCount)
    }

    func testSandwichesAreShownInCorrectOrderIfNoFaveExists() {
        // Arrange
        let getSandwichesResult: Result<[Sandwich], NetworkingError> = .success([
            Sandwich(id: 123, name: "Test Sandwich 123"),
            Sandwich(id: 456, name: "Test Sandwich 456"),
            Sandwich(id: 789, name: "Test Sandwich 789")
        ])

        spyOrderingAPI.getSandwichesResult = getSandwichesResult

        // Act
        viewModel.onViewWillAppear()

        // Assert
        let loadState = spyDelegate.displaySandwichLoadStateLastArg!
        switch loadState {
        case .loading, .failed:
            XCTFail("Sandwiches should be loaded")
        case .loaded(let displaySandwiches):
            XCTAssertEqual([123, 456, 789], displaySandwiches.map { $0.sandwich.id })
        }
    }

    func testSandwichesAreShownInCorrectOrderIfFaveExists() {
        // Arrange
        let getSandwichesResult: Result<[Sandwich], NetworkingError> = .success([
            Sandwich(id: 123, name: "Test Sandwich 123"),
            Sandwich(id: 456, name: "Test Sandwich 456"),
            Sandwich(id: 789, name: "Test Sandwich 789")
        ])

        spyOrderingAPI.getSandwichesResult = getSandwichesResult
        fakeFaveStorage.favoriteSandwichId = 456

        // Act
        viewModel.onViewWillAppear()

        // Assert
        let loadState = spyDelegate.displaySandwichLoadStateLastArg!
        switch loadState {
        case .loading, .failed:
            XCTFail("Sandwiches should be loaded")
        case .loaded(let displaySandwiches):
            XCTAssertEqual([456, 123, 789], displaySandwiches.map { $0.sandwich.id })
        }
    }
}

private class SpyDelegate: ChooseSandwichViewModelDelegate {
    private(set) var displaySandwichLoadStateCallCount = 0
    private(set) var displaySandwichLoadStateLastArg: ChooseSandwichViewModel.SandwichLoadState?
    private(set) var goToChooseCreditCardScreenCallCount = 0

    func displaySandwichLoadState(_ state: ChooseSandwichViewModel.SandwichLoadState) {
        displaySandwichLoadStateCallCount += 1
        displaySandwichLoadStateLastArg = state
    }

    func goToChooseCreditCardScreen() {
        goToChooseCreditCardScreenCallCount += 1
    }
}
