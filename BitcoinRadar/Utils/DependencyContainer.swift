import Foundation

protocol DependencyContainer: AnyObject {
    func makeHistoryRepository() -> HistoryRepositoryProtocol
    func makeLiveUpdateRepository() -> LiveUpdateRepositoryProtocol
    func makeHistoryUseCase() -> HistoryUseCaseProtocol
    func makeDayDetailUseCase(calendar: Calendar) -> DayDetailUseCaseProtocol
    func makeListViewModel() -> ListViewModel
    func makePriceDetailViewModel(for date: Date, calendar: Calendar) -> PriceDetailViewModel
    func makePriceFormatter() -> PriceFormatterProtocol
}

extension DependencyContainer {
    func makeDayDetailUseCase() -> DayDetailUseCaseProtocol {
        makeDayDetailUseCase(calendar: .current)
    }

    func makePriceDetailViewModel(for date: Date) -> PriceDetailViewModel {
        makePriceDetailViewModel(for: date, calendar: .current)
    }
}

final class AppDependencyContainer: DependencyContainer {
    static let shared = AppDependencyContainer()

    func makeHistoryRepository() -> HistoryRepositoryProtocol {
        HistoryRepository()
    }

    func makeLiveUpdateRepository() -> LiveUpdateRepositoryProtocol {
        LiveUpdateRepository()
    }

    func makeHistoryUseCase() -> HistoryUseCaseProtocol {
        HistoryUseCase(
            historyRepository: makeHistoryRepository(),
            liveUpdateRepository: makeLiveUpdateRepository()
        )
    }

    func makeDayDetailUseCase(calendar: Calendar) -> DayDetailUseCaseProtocol {
        DayDetailUseCase(
            historyRepository: makeHistoryRepository(),
            liveUpdateRepository: makeLiveUpdateRepository(),
            calendar: calendar
        )
    }

    func makeListViewModel() -> ListViewModel {
        ListViewModel(
            useCase: makeHistoryUseCase(),
            priceFormatter: makePriceFormatter()
        )
    }

    func makePriceDetailViewModel(for date: Date, calendar: Calendar) -> PriceDetailViewModel {
        PriceDetailViewModel(
            date: date,
            dayDetailUseCase: makeDayDetailUseCase(calendar: calendar),
            priceFormatter: makePriceFormatter(),
            calendar: calendar
        )
    }
    
    func makePriceFormatter() -> PriceFormatterProtocol {
        PriceFormatter()
    }
}
