import Foundation
import XCTest
@testable import BitcoinRadar

final class MockLiveUpdateRepository: LiveUpdateRepositoryProtocol {
    var result: [FiatCurrency: LivePrice] = [:]
    var latestCallCount = 0

    func latestPrice(for currencies: [FiatCurrency]) async throws -> [FiatCurrency : LivePrice] {
        latestCallCount += 1
        return result
    }
}
