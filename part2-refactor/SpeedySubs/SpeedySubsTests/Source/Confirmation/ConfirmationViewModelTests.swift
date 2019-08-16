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
        XCTAssertEqual(mockDelegate.confirmationMessageCallCount, 1)
        XCTAssertEqual(mockDelegate.confirmationMessageLastArg, "Order 23561 successfully placed!")
    }

    func testNavigationTriggeredOnDoneButtonTapped() {
        // Arrange
        let viewModel = ConfirmationViewModel(orderID: 23561)
        let mockDelegate = MockDelegate()
        viewModel.delegate = mockDelegate

        // Act
        viewModel.onDoneButtonTapped()

        // Assert
        XCTAssertEqual(mockDelegate.confirmationAcknowledgedCallCount, 1)
    }

}

private class MockDelegate: ConfirmationViewModelDelegate {
    private(set) var confirmationMessageCallCount = 0
    private(set) var confirmationMessageLastArg: String?
    private(set) var confirmationAcknowledgedCallCount = 0

    func confirmationMessage(message: String) {
        confirmationMessageCallCount += 1
        confirmationMessageLastArg = message
    }

    func confirmationAcknowledged() {
        confirmationAcknowledgedCallCount += 1
    }
}
