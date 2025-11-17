import XCTest
@testable import BitcoinRadar

@MainActor
final class ListViewModelTests: XCTestCase {
    func testLoadSuccessUpdatesStateToLoaded() async throws {
        let entry = HistoryListEntry(timestamp: 1, price: 100, liveUpdate: nil)
        let useCase = MockHistoryUseCase(result: .success([entry]))
        let formatter = StubPriceFormatter { amount, currency, _ in "\(currency.rawValue) \(Int(amount))" }

        let viewModel = ListViewModel(useCase: useCase, priceFormatter: formatter)

        await viewModel.load()

        guard case .loaded(let data) = viewModel.state else {
            return XCTFail("Expected loaded state")
        }
        XCTAssertEqual(data.first?.price, "EUR 100")
    }

    func testLoadFailureSetsErrorState() async {
        let useCase = MockHistoryUseCase(result: .failure(StubError()))
        let viewModel = ListViewModel(useCase: useCase, priceFormatter: StubPriceFormatter())

        await viewModel.load()

        guard case .error = viewModel.state else {
            return XCTFail("Expected error state")
        }
    }

    func testRefreshReplacesLoadedData() async {
        let entriesA = [HistoryListEntry(timestamp: 1, price: 100, liveUpdate: nil)]
        let entriesB = [HistoryListEntry(timestamp: 2, price: 200, liveUpdate: nil)]
        let useCase = SequentialHistoryUseCase(results: [.success(entriesA), .success(entriesB)])
        let formatter = StubPriceFormatter { amount, currency, _ in "\(currency.rawValue) \(Int(amount))" }

        let viewModel = ListViewModel(useCase: useCase, priceFormatter: formatter)

        await viewModel.load()
        await viewModel.refresh()

        guard case .loaded(let data) = viewModel.state else {
            return XCTFail("Expected loaded state")
        }
        XCTAssertEqual(data.first?.price, "EUR 200")
    }
}

final class SequentialHistoryUseCase: HistoryUseCaseProtocol {
    var results: [Result<[HistoryListEntry], Error>]
    private var callCount = 0

    init(results: [Result<[HistoryListEntry], Error>]) {
        self.results = results
    }

    func fetch() async throws -> [HistoryListEntry] {
        let index = min(callCount, results.count - 1)
        let result = results[index]
        callCount += 1
        return try result.get()
    }
}
