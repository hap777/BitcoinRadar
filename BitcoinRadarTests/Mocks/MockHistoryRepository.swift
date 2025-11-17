import Foundation
import XCTest
@testable import BitcoinRadar

final class MockHistoryRepository: HistoryRepositoryProtocol {
    var result: [PriceHistoryRecord] = []
    var resultsByCurrency: [FiatCurrency: [PriceHistoryRecord]]?
    var historyCallCount = 0

    func history(for currency: FiatCurrency) async throws -> [PriceHistoryRecord] {
        historyCallCount += 1
        if let resultsByCurrency {
            return resultsByCurrency[currency] ?? []
        }
        return result
    }
}
