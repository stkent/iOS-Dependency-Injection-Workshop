import XCTest
@testable import SpeedySubs

class ConfirmationViewModelTests: XCTestCase {

    func testConfirmationMessageWithCorrectOrderIDDisplayed() {
        // Arrange
        let viewModel = ConfirmationViewModel(orderID: 23561)
        let mockDelegate = MockDelegate()
        viewModel.delegate = mockDelegate

        // Act
        viewModel.onViewDidLoad()

        // Assert
        XCTAssertEqual(mockDelegate.showConfirmationMessageCallCount, 1)
        XCTAssertEqual(mockDelegate.showConfirmationMessageLastArg, "Order 23561 successfully placed!")
    }

    func testNavigationTriggeredOnDoneButtonTapped() {
        // Arrange
        let viewModel = ConfirmationViewModel(orderID: 23561)
        let mockDelegate = MockDelegate()
        viewModel.delegate = mockDelegate

        // Act
        viewModel.onDoneButtonTapped()

        // Assert
        XCTAssertEqual(mockDelegate.resetToChooseSandwichScreenCallCount, 1)
    }

}

private class MockDelegate: ConfirmationViewModelDelegate {
    private(set) var showConfirmationMessageCallCount = 0
    private(set) var showConfirmationMessageLastArg: String?
    private(set) var resetToChooseSandwichScreenCallCount = 0

    func showConfirmationMessage(message: String) {
        showConfirmationMessageCallCount += 1
        showConfirmationMessageLastArg = message
    }

    func resetToChooseSandwichScreen() {
        resetToChooseSandwichScreenCallCount += 1
    }
}
