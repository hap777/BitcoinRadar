import Foundation
import XCTest
@testable import BitcoinRadar

struct StubError: Error {}

struct StubPriceFormatter: PriceFormatterProtocol {
    var handler: ((Double, FiatCurrency, Int) -> String)?

    func format(amount: Double, currency: FiatCurrency, digits: Int) -> String {
        if let handler {
            return handler(amount, currency, digits)
        }
        return "\(currency.rawValue) \(amount)"
    }
}
