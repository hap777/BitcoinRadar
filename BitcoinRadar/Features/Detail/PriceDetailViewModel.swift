import Foundation
import Combine

@MainActor
final class PriceDetailViewModel: ObservableObject {
    @Published var state: DetailViewState = .loading

    private let dayDetailUseCase: DayDetailUseCaseProtocol
    private let priceFormatter: PriceFormatterProtocol
    private let targetDate: Date
    private let calendar: Calendar

    init(
        date: Date,
        dayDetailUseCase: DayDetailUseCaseProtocol,
        priceFormatter: PriceFormatterProtocol,
        calendar: Calendar = .current
    ) {
        self.targetDate = calendar.startOfDay(for: date)
        self.calendar = calendar
        self.dayDetailUseCase = dayDetailUseCase
        self.priceFormatter = priceFormatter
    }

    func load() async {
        do {
            let result = try await dayDetailUseCase.execute(for: targetDate)
            state = .loaded(
                .init(
                    date: result.date,
                    eur: priceFormatter.format(amount: result.eur, currency: .eur),
                    usd: priceFormatter.format(amount: result.usd, currency: .usd),
                    gbp: priceFormatter.format(amount: result.gbp, currency: .gbp)
                )
            )
        } catch {
            state = .error
        }
    }
}
