import XCTest
@testable import BitcoinRadar

final class HistoryRepositoryTests: XCTestCase {
    @MainActor
    func testHistoryReturnsMappedRecords() async throws {
        // given
        let dto = HistoricalData(data: [
            .init(timestamp: 1, open: 10, high: 20, low: 5, close: 15),
            .init(timestamp: 2, open: 11, high: 21, low: 6, close: 16)
        ])
        let client = MockAPIClient()
        client.response = dto
        let repository = HistoryRepository(client: client)

        // when
        let records = try await repository.history(for: .eur)

        // then
        XCTAssertEqual(records.count, 2)
        guard let firstRecord = records.first else {
            XCTFail("Expected first record")
            return
        }
        XCTAssertEqual(firstRecord.timestamp, 1)
        XCTAssertEqual(firstRecord.close, 15)
        XCTAssertEqual(client.executeCallCount, 1)
    }

    @MainActor
    func testHistoryUsesCacheForSameRequest() async throws {
        let dto = HistoricalData(data: [
            .init(timestamp: 1, open: 10, high: 20, low: 5, close: 15)
        ])
        let client = MockAPIClient()
        client.response = dto
        let repository = HistoryRepository(client: client)

        _ = try await repository.history(for: .eur)

        client.response = HistoricalData(data: [
            .init(timestamp: 999, open: 0, high: 0, low: 0, close: 0)
        ])

        let cached = try await repository.history(for: .eur)

        guard let cachedRecord = cached.first else {
            XCTFail("Expected cached record")
            return
        }

        XCTAssertEqual(cachedRecord.timestamp, 1)
        XCTAssertEqual(client.executeCallCount, 1, "Expected cached value to prevent second network call")
    }
}
