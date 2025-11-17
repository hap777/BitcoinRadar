import XCTest
@testable import BitcoinRadar

final class HistoryUseCaseTests: XCTestCase {
    @MainActor
    func testFetchReturnsLiveUpdateOnlyForToday() async throws {
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!

        let mockHistory = MockHistoryRepository()
        mockHistory.result = [
            PriceHistoryRecord(timestamp: yesterday.timeIntervalSince1970, open: 0, high: 0, low: 0, close: 100),
            PriceHistoryRecord(timestamp: today.timeIntervalSince1970, open: 0, high: 0, low: 0, close: 200)
        ]
        let livePrice = LivePrice(currency: .eur, value: 210, trend: .up, lastUpdateTimestamp: today.timeIntervalSince1970, lastUpdateQuantity: 0.1)
        let mockLive = MockLiveUpdateRepository()
        mockLive.result = [.eur: livePrice]

        let useCase = HistoryUseCase(historyRepository: mockHistory, liveUpdateRepository: mockLive)

        let entries = try await useCase.fetch()

        XCTAssertEqual(entries.count, 2)
        XCTAssertEqual(entries.first?.price, 200)
        XCTAssertNotNil(entries.first?.liveUpdate, "Today entry should include live update")
        XCTAssertNil(entries.last?.liveUpdate, "Past entries should not include live data")
    }

    @MainActor
    func testFetchAppendsTodayEntryWhenMissing() async throws {
        let today = Date()
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: today)!

        let mockHistory = MockHistoryRepository()
        mockHistory.result = [
            PriceHistoryRecord(timestamp: twoDaysAgo.timeIntervalSince1970, open: 0, high: 0, low: 0, close: 90),
            PriceHistoryRecord(timestamp: today.addingTimeInterval(-86_400).timeIntervalSince1970, open: 0, high: 0, low: 0, close: 95)
        ]
        let livePrice = LivePrice(currency: .eur, value: 220, trend: .up, lastUpdateTimestamp: today.timeIntervalSince1970, lastUpdateQuantity: 0.2)
        let mockLive = MockLiveUpdateRepository()
        mockLive.result = [.eur: livePrice]

        let useCase = HistoryUseCase(historyRepository: mockHistory, liveUpdateRepository: mockLive)

        let entries = try await useCase.fetch()

        XCTAssertEqual(entries.count, 3)
        XCTAssertEqual(entries.first?.price, livePrice.value, "New today entry should be inserted using live value")
        XCTAssertEqual(entries.first?.liveUpdate, livePrice)
    }
}
