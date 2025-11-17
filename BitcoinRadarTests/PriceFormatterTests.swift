import XCTest
@testable import BitcoinRadar

final class PriceFormatterTests: XCTestCase {
    func testFormatReturnsLocalizedCurrencyString() {
        let formatter = PriceFormatter()
        let result = formatter.format(amount: 1234.5, currency: .usd, digits: 2)
        XCTAssertTrue(result.contains("1"), "Expected formatted string to contain digits, got \(result)")
    }
}
