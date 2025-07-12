import XCTest
@testable import iControlBell

final class ConfirmationBannerTests: XCTestCase {
    func testShowConfirmationBannerWithTimer() {
        let appState = AppState(raulandManager: MockNetworkService())
        let expectation = XCTestExpectation(description: "Banner should hide after timer")
        appState.showConfirmationBannerWithTimer(text: "Test", seconds: 2)
        XCTAssertTrue(appState.showConfirmationBanner)
        XCTAssertEqual(appState.confirmationBannerText, "Test")
        XCTAssertEqual(appState.confirmationBannerSeconds, 2)
        // Wait for 3 seconds to ensure timer hides the banner
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssertFalse(appState.showConfirmationBanner)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 4)
    }
}
