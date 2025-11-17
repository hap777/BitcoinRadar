import XCTest
@testable import BitcoinRadar

final class DayDetailUseCaseTests: XCTestCase {
    @MainActor
    func testExecuteReturnsLiveDataForToday() async throws {
        let calendar = Calendar(identifier: .gregorian)
        let today = calendar.startOfDay(for: Date())

        let mockHistory = MockHistoryRepository()
        let mockLive = MockLiveUpdateRepository()
        mockLive.result = [
            .eur: LivePrice(currency: .eur, value: 1, trend: .up, lastUpdateTimestamp: 0, lastUpdateQuantity: 0),
            .usd: LivePrice(currency: .usd, value: 2, trend: .down, lastUpdateTimestamp: 0, lastUpdateQuantity: 0),
            .gbp: LivePrice(currency: .gbp, value: 3, trend: .up, lastUpdateTimestamp: 0, lastUpdateQuantity: 0)
        ]

        let useCase = DayDetailUseCase(historyRepository: mockHistory, liveUpdateRepository: mockLive, calendar: calendar)

        let detail = try await useCase.execute(for: today)

        XCTAssertEqual(detail.eur, 1)
        XCTAssertEqual(detail.usd, 2)
        XCTAssertEqual(detail.gbp, 3)
        XCTAssertEqual(mockLive.latestCallCount, 1)
        XCTAssertEqual(mockHistory.historyCallCount, 0)
    }

    @MainActor
    func testExecuteReturnsHistoricalDataForPastDate() async throws {
        let calendar = Calendar(identifier: .gregorian)
        let date = calendar.startOfDay(for: calendar.date(byAdding: .day, value: -1, to: Date())!)
        let record = PriceHistoryRecord(timestamp: date.timeIntervalSince1970, open: 0, high: 0, low: 0, close: 99)

        let mockHistory = MockHistoryRepository()
        mockHistory.resultsByCurrency = [
            .eur: [record],
            .usd: [record],
            .gbp: [record]
        ]
        let mockLive = MockLiveUpdateRepository()

        let useCase = DayDetailUseCase(historyRepository: mockHistory, liveUpdateRepository: mockLive, calendar: calendar)

        let detail = try await useCase.execute(for: date)

        XCTAssertEqual(detail.eur, 99)
        XCTAssertEqual(detail.usd, 99)
        XCTAssertEqual(detail.gbp, 99)
        XCTAssertEqual(mockHistory.historyCallCount, 3)
        XCTAssertEqual(mockLive.latestCallCount, 0)
    }
}
