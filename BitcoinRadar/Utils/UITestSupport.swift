#if DEBUG
import Foundation

enum UITestScenario: String {
    case listSuccess = "list_success"
    case listError = "list_error"
}

enum UITestConfiguration {
    static let scenarioKey = "UITEST_SCENARIO"

    static var currentScenario: UITestScenario? {
        guard let value = ProcessInfo.processInfo.environment[scenarioKey] else {
            return nil
        }
        return UITestScenario(rawValue: value)
    }
}

final class UITestDependencyContainer: DependencyContainer {
    private let scenario: UITestScenario

    init(scenario: UITestScenario) {
        self.scenario = scenario
    }

    func makeHistoryRepository() -> HistoryRepositoryProtocol {
        HistoryRepository()
    }

    func makeLiveUpdateRepository() -> LiveUpdateRepositoryProtocol {
        LiveUpdateRepository()
    }

    func makeHistoryUseCase() -> HistoryUseCaseProtocol {
        switch scenario {
        case .listSuccess:
            return StubHistoryUseCase(result: .success(sampleHistoryEntries))
        case .listError:
            return StubHistoryUseCase(result: .failure(UITestError.history))
        }
    }

    func makeDayDetailUseCase(calendar: Calendar) -> DayDetailUseCaseProtocol {
        switch scenario {
        case .listSuccess:
            return StubDayDetailUseCase(result: .success(sampleDetail))
        case .listError:
            return StubDayDetailUseCase(result: .failure(UITestError.detail))
        }
    }

    func makeListViewModel() -> ListViewModel {
        ListViewModel(useCase: makeHistoryUseCase(), priceFormatter: makePriceFormatter())
    }

    func makePriceDetailViewModel(for date: Date, calendar: Calendar) -> PriceDetailViewModel {
        PriceDetailViewModel(
            date: date,
            dayDetailUseCase: makeDayDetailUseCase(calendar: calendar),
            priceFormatter: makePriceFormatter(),
            calendar: calendar
        )
    }

    private var sampleHistoryEntries: [HistoryListEntry] {
        [
            HistoryListEntry(
                timestamp: firstEntryDate.timeIntervalSince1970,
                price: 42000,
                liveUpdate: LivePrice(
                    currency: .eur,
                    value: 42100,
                    trend: .up,
                    lastUpdateTimestamp: firstEntryDate.addingTimeInterval(600).timeIntervalSince1970,
                    lastUpdateQuantity: 0.1234
                )
            ),
            HistoryListEntry(
                timestamp: secondEntryDate.timeIntervalSince1970,
                price: 39000,
                liveUpdate: nil
            )
        ]
    }

    private var sampleDetail: DailyMultiCurrencyPrice {
        DailyMultiCurrencyPrice(
            date: firstEntryDate,
            eur: 42100,
            usd: 45000,
            gbp: 36000
        )
    }

    private var firstEntryDate: Date {
        Date(timeIntervalSince1970: 1_700_000_000)
    }

    private var secondEntryDate: Date {
        firstEntryDate.addingTimeInterval(-86_400)
    }
    
    func makePriceFormatter() -> PriceFormatterProtocol {
        PriceFormatter()
    }
}

private enum UITestError: Error {
    case history
    case detail
}

private struct StubHistoryUseCase: HistoryUseCaseProtocol {
    let result: Result<[HistoryListEntry], Error>

    func fetch() async throws -> [HistoryListEntry] {
        try result.get()
    }
}

private struct StubDayDetailUseCase: DayDetailUseCaseProtocol {
    let result: Result<DailyMultiCurrencyPrice, Error>

    func execute(for date: Date) async throws -> DailyMultiCurrencyPrice {
        try result.get()
    }
}
#endif
