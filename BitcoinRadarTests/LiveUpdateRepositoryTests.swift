import XCTest
@testable import BitcoinRadar

final class LiveUpdateRepositoryTests: XCTestCase {
    @MainActor
    func testLatestPriceMapsResponseToDomainModel() async throws {
        let dto = LiveUpdateData(data: [
            "BTC-EUR": .init(
                instrument: "BTC-EUR",
                value: 42000,
                valueFlag: .up,
                valueLastUpdate: 123,
                lastUpdateQuantity: 0.5
            )
        ])
        let client = MockAPIClient()
        client.response = dto
        let repository = LiveUpdateRepository(client: client)

        let prices = try await repository.latestPrice(for: [.eur])

        let eur = try XCTUnwrap(prices[.eur])
        XCTAssertEqual(eur.value, 42000)
        XCTAssertEqual(eur.trend, .up)
        XCTAssertEqual(eur.lastUpdateTimestamp, 123)
        XCTAssertEqual(eur.lastUpdateQuantity, 0.5)
    }
}
