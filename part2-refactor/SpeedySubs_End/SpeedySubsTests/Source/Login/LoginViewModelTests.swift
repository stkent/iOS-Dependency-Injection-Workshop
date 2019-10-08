import XCTest
@testable import SpeedySubs

class LoginViewModelTests: XCTestCase {

    private var spyOrderingAPI: SpyOrderingAPI!
    private var testSession: TestSession!
    private var spyDelegate: SpyDelegate!
    private var viewModel: LoginViewModel!

    override func setUp() {
        spyOrderingAPI = SpyOrderingAPI()
        testSession = TestSession()
        spyDelegate = SpyDelegate()
        viewModel = LoginViewModel(orderingAPI: spyOrderingAPI, session: testSession)
        viewModel.delegate = spyDelegate
    }

    func testErrorIsShowIfUsernameIsEmpty() {
        // Arrange
        let username = ""
        let password = "password"

        // Act
        viewModel.onCredentialsSubmitted(username: username, password: password)

        // Assert
        XCTAssertEqual(1, spyDelegate.displayValidationErrorMessageCallCount)
        XCTAssertEqual("Username cannot be blank", spyDelegate.displayValidationErrorMessageLastArg)
    }

    func testNoLoginCallIsMadeIfUsernameIsEmpty() {
        // Arrange
        let username = ""
        let password = "password"

        // Act
        viewModel.onCredentialsSubmitted(username: username, password: password)

        // Assert
        XCTAssertEqual(0, spyOrderingAPI.logInCallCount)
    }

    func testErrorIsShowIfPasswordIsEmpty() {
        // Arrange
        let username = "username"
        let password = ""

        // Act
        viewModel.onCredentialsSubmitted(username: username, password: password)

        // Assert
        XCTAssertEqual(1, spyDelegate.displayValidationErrorMessageCallCount)
        XCTAssertEqual("Password cannot be blank", spyDelegate.displayValidationErrorMessageLastArg)
    }

    func testNoLoginCallIsMadeIfPasswordIsEmpty() {
        // Arrange
        let username = "username"
        let password = ""

        // Act
        viewModel.onCredentialsSubmitted(username: username, password: password)

        // Assert
        XCTAssertEqual(0, spyOrderingAPI.logInCallCount)
    }

    func testLoginCallIsMadeIfUsernameAndPasswordAreNonEmpty() {
        // Arrange
        let username = "username"
        let password = "password"

        // Act
        viewModel.onCredentialsSubmitted(username: username, password: password)

        // Assert
        XCTAssertEqual(1, spyOrderingAPI.logInCallCount)
        XCTAssertEqual(username, spyOrderingAPI.logInLastUsername)
        XCTAssertEqual(password, spyOrderingAPI.logInLastPassword)
    }

    func testNavigationOccursIfLoginIsSuccessful() {
        // Arrange
        let username = "username"
        let password = "password"

        let logInCustomer = Customer(id: "any id", creditCards: [])
        let logInResult: Result<Customer, NetworkingError> = .success(logInCustomer)
        spyOrderingAPI.logInResult = logInResult

        // Act
        viewModel.onCredentialsSubmitted(username: username, password: password)

        // Assert
        XCTAssertEqual(1, spyDelegate.goToChooseSandwichScreenCallCount)
    }

    func testNavigationDoesNotOccurIfLoginIsUnsuccessful() {
        // Arrange
        let username = "username"
        let password = "password"

        let logInResult: Result<Customer, NetworkingError> = .failure(NetworkingError.noInternet)
        spyOrderingAPI.logInResult = logInResult

        // Act
        viewModel.onCredentialsSubmitted(username: username, password: password)

        // Assert
        XCTAssertEqual(0, spyDelegate.goToChooseSandwichScreenCallCount)
    }

    func testSessionIsUpdatedIfLoginIsSuccessful() {
        // Arrange
        let username = "username"
        let password = "password"

        let logInCustomer = Customer(id: "123456", creditCards: [])
        let logInResult: Result<Customer, NetworkingError> = .success(logInCustomer)
        spyOrderingAPI.logInResult = logInResult

        // Act
        viewModel.onCredentialsSubmitted(username: username, password: password)

        // Assert
        XCTAssertEqual(logInCustomer.id, testSession.customer?.id)
    }
}

private class SpyDelegate: LoginViewModelDelegate {
    private(set) var displayValidationErrorMessageCallCount = 0
    private(set) var displayValidationErrorMessageLastArg: String?
    private(set) var displayProgressViewsCallCount = 0
    private(set) var hideProgressViewsCallCount = 0
    private(set) var displayErrorCallCount = 0
    private(set) var displayErrorLastArg: Error?
    private(set) var goToChooseSandwichScreenCallCount = 0

    func displayValidationErrorMessage(_ message: String) {
        displayValidationErrorMessageCallCount += 1
        displayValidationErrorMessageLastArg = message
    }

    func displayProgressViews() {
        displayProgressViewsCallCount += 1
    }

    func hideProgressViews() {
        hideProgressViewsCallCount += 1
    }

    func displayError(_ error: Error) {
        displayErrorCallCount += 1
        displayErrorLastArg = error
    }

    func goToChooseSandwichScreen() {
        goToChooseSandwichScreenCallCount += 1
    }
}
