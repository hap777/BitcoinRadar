import Foundation

protocol DayDetailUseCaseProtocol {
    func execute(for date: Date) async throws -> DailyMultiCurrencyPrice
}

struct DayDetailUseCase: DayDetailUseCaseProtocol {
    let historyRepository: HistoryRepositoryProtocol
    let liveUpdateRepository: LiveUpdateRepositoryProtocol
    let calendar: Calendar

    func execute(for date: Date) async throws -> DailyMultiCurrencyPrice {
        if calendar.isDateInToday(date) {
            let live = try await liveUpdateRepository.latestPrice(for: [.eur, .usd, .gbp])
            return DailyMultiCurrencyPrice(
                date: date,
                eur: live[.eur]?.value ?? 0,
                usd: live[.usd]?.value ?? 0,
                gbp: live[.gbp]?.value ?? 0
            )
        } else {
            // For past day: ask history in 3 currencies
            async let eur = history(for: date, currency: .eur)
            async let usd = history(for: date, currency: .usd)
            async let gbp = history(for: date, currency: .gbp)

            let (eurPrice, usdPrice, gbpPrice) = try await (eur, usd, gbp)

            guard let eurPrice,
                  let usdPrice,
                  let gbpPrice
            else {
                throw NSError(domain: "PriceDetail", code: 0, userInfo: [
                    NSLocalizedDescriptionKey: "No price data for selected date."
                ])
            }

            return DailyMultiCurrencyPrice(
                date: date,
                eur: eurPrice.close,
                usd: usdPrice.close,
                gbp: gbpPrice.close
            )
        }
    }

    func history(for date: Date, currency: FiatCurrency) async throws -> PriceHistoryRecord? {
        let histories = try await historyRepository.history(for: currency)
        return histories.first(where: {
            let entryDate = Date(timeIntervalSince1970: $0.timestamp)
            return calendar.startOfDay(for: entryDate) == date
        })
    }
}
